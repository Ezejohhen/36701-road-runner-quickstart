# Road Runner registrar startup fix

The supplied `hub-logcat-full.txt` identifies the failure as an InvocationTargetException
whose cause is a NullPointerException in `TuningOpModes.register()` at the original
line 308. `FtcDashboard.getInstance()` was null when `withConfigRoot()` was called.

## Cause

The log shows Sloth 0.3.2 invoking the registrar on a scanner worker thread at
19:00:32.329, with the null-reference cause at 19:00:32.355. The later
OnCreateEventLoop hooks run on the activity thread at 19:00:34.200.

Inspection of the actual dependency bytecode confirms that Dashboard 0.5.1 creates
its singleton in `start(Context)`, annotated with the SDK's `@OnCreate`. Sloth's
SDKOpModeRegistrar invokes registrars during scanning, with an independent scanner
ordering rule. Completing discovery of OnCreate hooks is not the same as completing
their execution. Thus registration under this lifecycle can happen before Dashboard
initialization; this registrar's assumption that the singleton already exists is invalid.
No dependency version change is needed to address that assumption.

## Change

Only `TeamCode/src/main/java/org/firstinspires/ftc/teamcode/tuning/TuningOpModes.java`
was changed in robot source:

- Keep all existing OpMode registrations in their original order.
- Extract the existing six-class Dashboard configuration block into a helper that
  reads the singleton once and returns safely when it is null.
- Call the helper from the registrar, preserving configuration for later registrations
  where Dashboard is already initialized.
- Add a public static SDK `@OnCreateEventLoop` hook with the supported Context and
  FtcEventLoop signature. It retries the same configuration after activity creation.
- Honor the existing DISABLED flag. If Dashboard remains unavailable at the later
  hook, log a warning under `TuningOpModes` instead of dereferencing null.

The hook does not depend on whether Dashboard's own attachEventLoop hook runs first:
it only needs the singleton created during OnCreate. Repeated configuration replaces
the same named entries; it does not register extra OpModes. No early Dashboard.start()
call, background polling, registrar disabling, or dependency changes were introduced.

All tuning programs and the same six Dashboard configuration entries are retained.
If Dashboard never initializes, its configuration controls cannot be provided, and
Dashboard-dependent tuners may still require Dashboard to run. This fix handles the
reported startup null reference; it does not replace Dashboard itself.

TeleOp, autonomous routines, drive configuration, motor names, and Pedro settings
were not changed. FTC SDK 11.2.0 and app version 11.2/code 62 are unchanged.
`UPLOAD_TO_ROBOT.md` was updated with registrar and Dashboard checks; this document
records the findings. Existing SDK-upgrade changes and the supplied log were preserved.

## Local verification

```powershell
.\gradlew.bat clean :TeamCode:assembleDebug
.\gradlew.bat --offline :TeamCode:assembleDebug
```

- Clean build: successful, 1m 24s, all 56 tasks executed.
- Offline build: successful, 9s, 7 executed / 47 up-to-date.
- Inspected compiled bytecode: helper branches around the null dereference; later
  callback carries the runtime-visible OnCreateEventLoop annotation.
- Verified APK package/version and existing signing certificate with AAPT/apksigner.
- Existing Java 8/deprecated API, native symbol stripping, SDK parser, and Gradle
  deprecation warnings remain nonfatal. No system tools were installed or upgraded.

APK: `TeamCode/build/outputs/apk/debug/TeamCode-debug.apk`.

No robot deployment or hardware test was performed. Follow
[UPLOAD_TO_ROBOT.md](UPLOAD_TO_ROBOT.md) while offline. After installation, confirm
the registrar error is gone, quickstart tuning programs remain listed, and Dashboard
shows AngularRampLogger and ManualFeedforwardTuner configuration entries without
starting the robot or changing their values. If those entries are absent, collect
the `TuningOpModes` and lifecycle logs before changing anything else.
