# FTC SDK 11.2 upgrade verification

Verified locally on Windows, November 6, 2026. Nothing was pushed, connected to the
Control Hub, installed on the robot, or changed in the system tool installations.

## Files changed

| File | Change and reason |
| --- | --- |
| `build.dependencies.gradle` | Upgrade all eight FTC artifacts together from 11.0.0 to 11.2.0. |
| `FtcRobotController/src/main/AndroidManifest.xml` | Set official app version name 11.2 and version code 62. The existing common Gradle script reads these into the TeamCode application. |
| `WINDOWS_FTC_SETUP_GUIDE.md` | Correct the version table to the existing Gradle/AGP versions and SDK 11.2; specify Build Tools 35.0.0 for the existing AGP. Keep the historical account of the earlier 11.0 installation. |
| `UPLOAD_TO_ROBOT.md` | Add offline preparation, SDK version checks, the current TeleOp name, an existing autonomous limitation, and installation of the prepared APK as a fallback. |
| `SDK_11_2_UPGRADE.md` | Record upgrade scope, evidence, warnings, and limitations. |

No team Java/Kotlin code, hardware names, motor directions, path coordinates, tuning
values, robot configurations, signing keys, or application ID were changed.

## Official SDK comparison and build configuration

Reviewed the [official v11.2 release](https://github.com/FIRST-Tech-Challenge/FtcRobotController/releases/tag/v11.2),
its [release notes](https://github.com/FIRST-Tech-Challenge/FtcRobotController/blob/v11.2/README.md),
the [11.0 to 11.2 file comparison](https://github.com/FIRST-Tech-Challenge/FtcRobotController/compare/v11.0...v11.2),
and the tagged Gradle scripts and manifest.

The upstream comparison changes the dependency versions, app manifest, documentation,
several examples, and adds two optional test Utility OpModes. The internal Robot
Controller activity and permission wrapper do not change between those tags. Example
changes and optional test OpModes are not required to load the team's programs and
were not copied into this project.

There is an upstream inconsistency: the v11.2 README describes Gradle 9.1 / AGP 8.13.2,
while that tag's actual build.gradle and wrapper still specify AGP 8.7.0 / Gradle 8.9.
This project already had AGP 8.13.2 / Gradle 8.13. That existing combination built
successfully and was retained to minimize changes. Gradle 9 migration is outside this
upgrade and existing plugins report deprecations affecting that migration.

Retained JDK 21 through JAVA_HOME, Kotlin plugin 2.3.10, Java/Kotlin bytecode target
1.8, compile SDK 30, minimum SDK 24, target SDK 28, AndroidX settings, the shared FTC
debug keystore, both ARM ABIs, and existing native library packaging rules. The
FtcRobotController module remains a library and TeamCode remains the complete Android
application. The existing IntelliJ TeamCode Run configuration remains valid; Android
Studio is not needed for this verified command-line build.

The PATH java command resolves to Java 17 on this laptop, but gradlew uses JAVA_HOME
and confirmed Temurin 21. Set IntelliJ's Gradle JVM to that same JDK 21.

## Third-party dependencies and the scanning error

All third-party versions were preserved:

| Library | Version |
| --- | --- |
| Pedro revhub / resolved core | 3.0.2 |
| Pedro tuning | 1.0.3 |
| Pedro Ivy pedro / core | 1.1.1 |
| Road Runner FTC | 0.1.25 |
| Road Runner core / actions | 1.0.1 |
| FTC Dashboard / core | 0.5.1 |
| AndroidX appcompat | 1.2.0 |

Reviewed published Ivy 1.1.1 metadata and class files. Its pedro integration brings
Ivy core 1.1.1 and does not force a newer FTC dependency. Its APIs used by Auton.kt
compile successfully against the unchanged Pedro versions and FTC 11.2.0; both Ivy
Scheduler and PedroCommands are present in the APK. There is no demonstrated need
to upgrade Ivy. This verifies build/link compatibility, not operation on hardware.

The missing Utility reference was found in **Sloth 0.3.2's
dev.frozenmilk.sinister.sdk.opmodes.AnnotatedOpModeScanner**, a transitive dependency
of Pedro tuning 1.0.3. It was not found in the Ivy artifacts. SDK 11.0 lacks the new
annotation, so scanning an ordinary Autonomous class can expose the scanner's missing
dependency even though that team class does not import Utility. The updated APK
contains an actual definition of com.qualcomm.robotcore.eventloop.opmode.Utility,
which addresses this specific missing class. Robot-side confirmation is still needed.

**AutoPath exists:** Auton.kt declares
org.firstinspires.ftc.teamcode.AutoPath and annotates it with the display name AutoPath.
The crash class therefore matches this repository; it is not evidence by itself of
different robot code. The exact installed APK was not inspected.

The resolved dependency graph selects every FTC artifact at 11.2.0, including Road
Runner/Dashboard's older FTC requests. Pedro tuning also brings Sloth 0.3.2,
Sinister 2.3.0, Dairy Util 1.2.2, jnanoid and nanohttpd-websocket. Kotlin stdlib
resolves to 2.4.10 through existing transitives; this selection was already present
before the upgrade, and Kotlin compilation passed without changing the compiler.
The FTC Vision chain retains EasyOpenCV 1.7.3, OpenCV 4.10.0-A and AprilTag 2.1.0.

## Verification results

Commands run from the project root:

```powershell
.\gradlew.bat --version
.\gradlew.bat :TeamCode:dependencies --configuration debugRuntimeClasspath
.\gradlew.bat clean :TeamCode:assembleDebug
.\gradlew.bat --offline :TeamCode:assembleDebug
```

- Clean build: **BUILD SUCCESSFUL**, 3m 30s, 56 tasks executed.
- Offline build: **BUILD SUCCESSFUL**, 18s, 7 tasks executed and 47 up-to-date.
- AAR metadata checks, duplicate-class checks, Kotlin/Java compilation, dexing,
  resource processing, signing, and APK packaging passed.
- AAPT checked the actual APK: package com.qualcomm.ftcrobotcontroller,
  versionName 11.2, versionCode 62, minimum API 24, target API 28, ARM32 and ARM64.
- APK signer verification passed using the existing Android debug certificate.
- Parsed APK DEX class definitions and confirmed Utility, AutoPath,
  BioBuzzStarterBotTeleopCustom, Ivy Scheduler, Ivy PedroCommands,
  Road Runner FTC Actions, and the Sloth scanner are packaged.
- git diff confirms there are no robot source changes.

APK:

```text
C:\Users\ezejo\IdeaProjects\36701-road-runner-quickstart\TeamCode\build\outputs\apk\debug\TeamCode-debug.apk
```

Local audit logs and reference downloads are in `.gradle/sdk-upgrade-audit/`
(ignored by Git). Rebuilding can change the APK hash because the existing build
generates APP_BUILD_TIME each time.

## Remaining warnings and limitations

- **Existing autonomous blocker:** TeamCode's pedro/Constants.java returns null from
  Constants.create(). AutoPath calls that factory and then uses the result as a
  Follower, so it cannot run successfully until the team supplies its actual drivetrain,
  localizer, and follower configuration. No hardware assumptions were invented here.
- SDK XML schema version 4 vs parser version 3 warning: the installed Android tools
  and parser differ in age. It did not prevent either build; no SDK tools were upgraded.
- JDK 21 warns that Java source/target 8 is obsolete, and source uses deprecated APIs.
  The Java 8 targets were preserved for the robot runtime.
- Native libraries could not be stripped and were packaged as supplied. This does not
  prevent APK installation; no NDK installation was needed.
- Gradle reports deprecated features incompatible with a future Gradle 9 migration.
- No on-robot scanning, Driver Station reconnection, hardware behavior, or signing-key
  match with the currently installed app was tested. Follow the saved
  [deployment instructions](UPLOAD_TO_ROBOT.md). Do not accept an uninstall prompt;
  ask the coach if signatures differ.
