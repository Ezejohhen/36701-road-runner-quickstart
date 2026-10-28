# Windows setup: Stripes & Circuits, FTC Team 36701

Use this guide **once per laptop**. At practice, use [UPLOAD_TO_ROBOT.md](UPLOAD_TO_ROBOT.md).
An **IDE** is the app where we edit code. Our IDE is IntelliJ IDEA. A **build** turns our
Kotlin and Java files into the Android app that runs on the REV Control Hub.

## 1. Before you start

- A Windows 10/11 laptop, charger, normal internet connection, and several GB of free space.
- Permission from a parent/school to install development software. Ask an adult if Windows
  requests an administrator password; do not bypass school restrictions.
- A GitHub account if you will contribute code. Ask the coach for repository access.
- For the final upload only: the powered Control Hub, its Wi-Fi name/password from the coach,
  and the team's Driver Station. Never put the password into GitHub or a script.

Finish setup and the first build on **normal Wi-Fi**. Robot Wi-Fi usually has no internet.

### The versions this project uses

| Part | Team configuration |
| --- | --- |
| IntelliJ on the repaired laptop | IDEA 2026.1.3 with Android support |
| Java Development Kit (JDK) | Eclipse Temurin **21**, Windows x64 JDK |
| Gradle (downloads automatically) | **8.9**, from this repository's wrapper |
| Android Gradle Plugin / Kotlin build plugin | **8.7.0 / 2.3.10**, already in the project |
| Android SDK platform / Build Tools | **Android 30 / 34.0.0** |
| FTC SDK | **11.0.0** |
| Road Runner | core/actions **1.0.1**, FTC **0.1.25** |
| FTC Dashboard | **0.5.1** |

The **Android SDK** is Google's set of Android build and connection tools.
You do not need Android Studio, an emulator, the Android NDK, or a separate Gradle installation
for this project's debug build. Do not accept suggested project upgrades during setup.

## 2. Install IntelliJ IDEA and its plugins

1. Download IntelliJ IDEA from [JetBrains](https://www.jetbrains.com/idea/download/).
   To match the coach laptop, use **2026.1.3** from
   [Other versions](https://www.jetbrains.com/idea/download/other.html).
2. Open the Windows installer and follow its prompts. Launch IntelliJ afterward.
3. At the Welcome screen, click **Plugins**. If a project is open, use
   **File > Settings > Plugins** instead.
4. In **Marketplace**, search for **Android**, check that the publisher is JetBrains,
   and install it. Install **Android Design Tools** too if offered separately for your
   IDEA version. Some versions include these tools with the Android plugin.
5. In **Installed**, make sure **Kotlin**, **Gradle**, and **Git** are enabled.
   They are normally included. Do not install a second Kotlin plugin from another publisher.
6. Click **Apply**, **OK**, and restart IntelliJ if requested.

If Android support is unavailable for your IDEA version, use the team's known version above
or ask the coach before changing the project. JetBrains documents the separate Android plugins
in its [Android support page](https://www.jetbrains.com/help/idea/create-your-first-android-application.html).

**Screenshot placeholder:** File > Settings > Plugins > Installed, showing Android support,
Kotlin, Gradle, and Git enabled. Do not include account information.

## 3. Install Java 21

The **JDK** contains the Java tools that Gradle needs. IntelliJ's own runtime is not necessarily
the same Java installation used to build our robot app.

1. Open [Eclipse Temurin downloads](https://adoptium.net/temurin/releases/?version=21&os=windows&arch=x64).
2. Select **21 (LTS)**, **Windows**, **x64**, **JDK**, and download the **MSI** installer.
   Do not select JRE or a different major version.
3. Run the installer. In **Custom Setup**, enable **Add to PATH** and **Set JAVA_HOME variable**
   (click a red X and choose to install that feature if necessary).
4. Finish, then close and reopen IntelliJ and any PowerShell windows.
5. Open Windows Start, type **PowerShell**, and open **Windows PowerShell** normally.
   Type this command and press Enter:

   ```powershell
   java -version
   ```

   The version should start with **21**. Then type:

   ```powershell
   $env:JAVA_HOME
   ```

   This should show the JDK 21 folder, not its `bin` folder. If it is blank or points to another
   Java version, rerun the Temurin installer and enable the JAVA_HOME option, then reopen PowerShell.

## 4. Install the Android SDK without Android Studio

Use your own Windows account's SDK folder so routine work does not need administrator access.
The coach laptop already uses `C:\Android\Sdk`; that existing location also works.

1. Open [Google's Android downloads](https://developer.android.com/studio#command-line-tools-only).
   Under **Command line tools only**, download the **Windows** ZIP after reviewing its license.
2. Open **File Explorer > Downloads**. Right-click the ZIP > **Extract All... > Extract**.
3. In File Explorer's address bar, type `%LOCALAPPDATA%` and press Enter. Create the folders
   `Android`, then `Sdk`, then `cmdline-tools`, then `latest` inside one another.
4. Open the extracted ZIP's `cmdline-tools` folder. Copy its **contents** (`bin`, `lib`,
   `source.properties`, and the other included files) into your new `latest` folder.
   Do not put another `cmdline-tools` folder inside `latest`.
5. Confirm that this file exists:

   ```text
   %LOCALAPPDATA%\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat
   ```

6. In **Windows PowerShell**, copy and run this whole line:

   ```powershell
   & "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat" "--sdk_root=$env:LOCALAPPDATA\Android\Sdk" "platform-tools" "platforms;android-30" "build-tools;34.0.0"
   ```

   Read the license prompts and answer `y` only if you accept them. Wait for installation to finish.
   **Platform Tools** includes ADB, the tool that sends the app to the Hub.
7. If Gradle later reports an unaccepted SDK license, run:

   ```powershell
   & "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat" "--sdk_root=$env:LOCALAPPDATA\Android\Sdk" --licenses
   ```

Do not use an “update everything” command. These specific packages are sufficient for this build.
Google's [sdkmanager reference](https://developer.android.com/tools/sdkmanager) explains the installer.

**Screenshot placeholder:** File Explorer showing `Sdk\cmdline-tools\latest\bin\sdkmanager.bat`
and the sibling `Sdk\platform-tools\adb.exe`. This helps catch an extra nested folder.

## 5. Get the team project

Use **Git** so you can download teammates' changes later. Git keeps a history of code changes.

1. Install Git for Windows from [git-scm.com](https://git-scm.com/downloads/win).
   The default installer options are suitable. Restart IntelliJ afterward.
2. On IntelliJ's Welcome screen, click **Clone Repository** (some versions say **Get from VCS**).
   With another project open, use **File > New > Project from Version Control...**.
3. Paste the repository URL:

   ```text
   https://github.com/Ezejohhen/36701-road-runner-quickstart
   ```

4. Keep the destination folder name **36701-road-runner-quickstart**, for example
   `C:\Users\YOURNAME\IdeaProjects\36701-road-runner-quickstart`. Click **Clone**.
5. Open/trust this team project when asked. If GitHub asks you to sign in, do that yourself;
   ask the coach if you do not have access. Never paste a password or token into a project file.

If you already have the project, choose **File > Open...** and select its **outer folder**:
the one containing `settings.gradle`, `gradlew.bat`, `TeamCode`, and `FtcRobotController`.
Do not open just `Drawing.kt` or just the TeamCode folder.

## 6. Point the project at your SDK and Java

1. In IntelliJ's left **Project** panel, right-click the outer project folder > **Open In > Terminal**.
   Alternatively open the **Terminal** tool window at the bottom. Select PowerShell if necessary.
   Check that its prompt ends in `36701-road-runner-quickstart`.
2. For the per-user SDK installed in section 4, paste:

   ```powershell
   Set-Content -Encoding ASCII local.properties ('sdk.dir=' + ($env:LOCALAPPDATA + '/Android/Sdk').Replace('\','/'))
   ```

   This creates **local.properties**, a file used only on your laptop. If using an existing
   `C:\Android\Sdk` instead, use `Set-Content -Encoding ASCII local.properties 'sdk.dir=C:/Android/Sdk'`.
   Do not copy the coach's user paths. Git ignores this file.
3. Open **File > Settings > Build, Execution, Deployment > Build Tools > Gradle**.
   Set **Distribution** to **Wrapper** (or **gradle-wrapper.properties**).
   Set **Gradle JVM** to your installed **Temurin 21**. **JAVA_HOME** is also fine if section 3
   showed the correct JDK. If absent, use **Add JDK...** and select its installation folder.
4. Open **File > Project Structure... > Project**. Select the same **JDK 21** as the project SDK.
   If Android tools ask for an Android SDK location, browse to the `Sdk` folder from section 4,
   not `platforms` or `platform-tools`. Keep **local.properties** pointed at that same folder.
5. Click **Apply > OK**. Press **Ctrl+Shift+A**, type **Sync Project with Gradle Files**,
   select that action, and press Enter. Gradle downloads this project's libraries from the internet.
   Wait until the **Build > Sync** results finish. The first sync can take several minutes.

Do not change the Java/Kotlin bytecode target from 1.8: the build uses JDK 21 but produces code
for the robot's older Android runtime. Warnings about Java 8 being obsolete are not build failures.

**Screenshot placeholder:** Gradle Settings with Wrapper and Temurin 21 selected; a second image
of a completed successful Sync. Hide personal paths if sharing screenshots publicly.

## 7. Build before going to the robot

1. Stay on normal Wi-Fi. In IntelliJ's PowerShell Terminal at the project root, run:

   ```powershell
   .\gradlew.bat :TeamCode:checkDebugAarMetadata :TeamCode:assembleDebug
   ```

2. Wait for **BUILD SUCCESSFUL**. AAR metadata checks make sure the Android libraries fit our SDK.
   An **APK** is the Android installation file. The result is:
   `TeamCode\build\outputs\apk\debug\TeamCode-debug.apk`.
3. Later you can build without typing: open **View > Tool Windows > Gradle**, expand
   **36701-road-runner-quickstart > TeamCode > Tasks > build**, and double-click **assembleDebug**.
   Use the Terminal command above if that task is hidden. Building does not upload or run motors.

## 8. Check the Run configuration once

A **run configuration** tells IntelliJ which app to upload. The shared **TeamCode** configuration
is stored in `.run/TeamCode.run.xml`. It should appear after Gradle sync.

1. Open the top Run configuration dropdown > **Edit Configurations...** (also under **Run**).
2. Select **TeamCode** under **Android App**.
3. Confirm **Module** is `36701-road-runner-quickstart.TeamCode` (some versions abbreviate it to TeamCode).
4. Under **Installation Options**, deploy the **Default APK**. Under **Launch Options**,
   choose **Default Activity**. Leave **Clear app storage** unchecked.
5. Under **Before launch**, keep **Gradle-aware Make** / the Android Gradle build task enabled.
   Click **Apply > OK**. Select **TeamCode** in the top dropdown.

TeamCode packages the entire FTC Robot Controller app, including FtcRobotController and your OpModes.
**FtcRobotController is a library**, so do not create another Android App configuration for it.
The temporary `:TeamCode:assemble` configuration only builds. **Current File** cannot upload a TeleOp.

If TeamCode is missing, sync first. Only if it remains absent, open **Run > Edit Configurations...**,
click **+**, choose **Android App**, name it **TeamCode**, and use the settings above.
Do not leave duplicate TeamCode entries.

**Screenshot placeholder:** TeamCode's Android App settings showing the module, Default APK,
Default Activity, and the before-launch build task; then the toolbar's TeamCode and device dropdowns.

## 9. Add the Connect Control Hub button in IntelliJ

This optional shortcut opens the same helper as double-clicking the batch file. Set it up
**once on each laptop**; IntelliJ toolbar and External Tool settings do not come from GitHub.
The coach laptop already has it. Leave **TeamCode** selected for normal uploads.

### Create the connection action

1. Open **File > Settings > Tools > External Tools**.
2. If **Connect Control Hub** already exists, use that entry instead of adding a duplicate.
   Otherwise click **+** to open **Create Tool**.
3. Enter these values exactly. The `$ProjectFileDir$` text is an IntelliJ shortcut for the
   open project's outer folder; keep the dollar signs and quotation marks shown below.

   | Field | Value |
   | --- | --- |
   | Name | `Connect Control Hub` |
   | Group | `External Tools` |
   | Program | `C:\Windows\System32\cmd.exe` |
   | Arguments | `/d /c start "" "$ProjectFileDir$\tools\connect-control-hub.bat"` |
   | Working directory | `$ProjectFileDir$` |

4. Click **OK** in Create Tool, then **Apply > OK** in Settings.
   This only saves the action. Do not run it until you are ready to connect to the Hub.

### Put the action on the top toolbar

1. Right-click an empty area of IntelliJ's **top toolbar** and choose **Customize Toolbar...**.
2. Expand **Main Toolbar > Left** and select **General Actions**.
3. Click **Add...**. In the search box, type **Connect Control Hub**.
4. Select **External Tools > External Tools > Connect Control Hub** in the results.
   Keep **Default icon**, then click **OK**.
5. Click **OK** again to save the toolbar layout.

You should now see a **small round, dotted icon** near the branch name (usually **master**),
to the left of the device selector. Its tooltip is **Connect Control Hub**. The exact position
can shift when you resize IntelliJ. Click it **after joining the Hub's Wi-Fi** to open the helper
window, then wait for **SUCCESS** before using the green TeamCode Run button.

If the button is missing, the File Explorer method still works:
open the project's `tools` folder and double-click `connect-control-hub.bat`.
This connection button does not change Wi-Fi, upload code, or replace the TeamCode Run button.

**Screenshot placeholder:** Create Tool with the five fields above, then Customize Main Toolbar
with Connect Control Hub under General Actions, then the top toolbar with the round button marked.

## 10. Connect and upload at the robot

Arrange this test with the coach. Keep the robot supported safely and clear of people.

1. Turn on the Hub. Finish edits and build successfully on normal Wi-Fi first.
2. In Windows, click the taskbar network/sound area, open the Wi-Fi network list
   (**Manage Wi-Fi connections** on Windows 11), choose the **team's Control Hub network**, and click
   **Connect**. Enter its password yourself. “No internet” is expected. Stay connected.
3. Click IntelliJ's **Connect Control Hub** toolbar button from section 9. Alternatively,
   in File Explorer open the project's **tools** folder and double-click **connect-control-hub.bat**
   (Type: Windows Batch File). Keep the neighboring `.ps1` file with it.
4. Wait for **SUCCESS: Control Hub ready**. Note the device address/serial shown.
   Press any key to close the helper window.
5. Back in IntelliJ, select **TeamCode**, then select that Hub in the device dropdown
   that previously said **No Devices**. Click the **green Run triangle**, not Debug.
6. Wait until IntelliJ reports that installation/launch completed. The Driver Station may disconnect
   briefly while the Robot Controller app restarts. Do not unplug/restart during installation.
7. On the connected Driver Station, open the **TeleOp** list and select
   **BioBuzz StarterBot Teleop** (group: **StarterBot**). A coach should supervise INIT/START.
8. After programming, reconnect the laptop to normal Wi-Fi for GitHub and dependency downloads.

**Wi-Fi and ADB are two different connections.** Windows Wi-Fi connects the laptop to the robot's
network; the helper establishes **ADB (Android Debug Bridge)** so IntelliJ can upload.
The helper does not change networks, upload code, store passwords, or disconnect other ADB devices.
It may start ADB's normal local server. A success result can also identify an already-connected USB Hub.
No laptop pairing mode or QR-code pairing is needed for this Control Hub workflow.
FIRST documents the Hub's [wireless ADB connection](https://ftc-docs.firstinspires.org/en/latest/programming_resources/shared/managing_control_hub/Managing-a-Control-Hub.html).

The default Hub address is **192.168.43.1:5555**. If the coach has changed the robot network,
ask for the actual address. A coach can run, from the project Terminal:
` .\tools\connect-control-hub.bat -HubAddress 192.168.50.1:5555 ` (replace the example address).
Students using the normal network can use the toolbar button or double-click the helper.

## 11. Download the latest team code

Do this on **normal Wi-Fi**, before switching to robot Wi-Fi.

1. Save your files with **Ctrl+S**.
2. If you have edits you want to keep, use the **Commit** tool window to review and commit them
   to your working branch, or ask the coach to help. A commit saves a local checkpoint; pushing
   shares it. Do not discard files to make an update work.
3. Choose **Git > Pull...**, use remote **origin** and the team's **master** branch (or the branch
   the coach assigned), then click **Pull**. Stop and ask for help if Git reports a conflict.
4. Sync again if IntelliJ requests it. Run **assembleDebug** before switching Wi-Fi.

These setup files must first be pushed by the coach before a second laptop can download them.
Do not commit `local.properties`, `.idea/workspace.xml`, SDKs, APKs, passwords, or access tokens.

## If something goes wrong

| What you see | What to do |
| --- | --- |
| **Current file is not runnable** | Select **TeamCode** in the top dropdown instead of **Current File**. A TeleOp runs inside the controller app, not as a desktop Kotlin program. |
| **No Devices** | Join Hub Wi-Fi, then run the helper. Both steps are required. Select the serial/address it reports; wait a few seconds for the dropdown to refresh. |
| SDK location not found / missing Android SDK | Check `local.properties` points to your SDK folder, containing `platform-tools` and `platforms\android-30`. Follow sections 4 and 6, then sync. |
| Missing dependencies / could not resolve / download failed | Return to normal internet Wi-Fi. Turn off Gradle **Toggle Offline Mode** if enabled in its tool window. Sync and build again; keep the full first error if it fails. |
| Gradle sync failed | Open **View > Tool Windows > Build**, select **Sync**, and read the first error. Check internet, Java 21, and SDK location. Do not accept upgrades or delete caches as the first fix. |
| Wrong Java / unsupported class file / JAVA_HOME invalid | Repeat section 3 and set **Gradle JVM** explicitly to Temurin 21 in section 6. Reopen IntelliJ/Terminal after installation changes. |
| AAR metadata / compileSdk compatibility error | Use the latest team code. This repair removes unused Core KTX 1.19.1; do not add it back or change compileSdk to 37. Send the full dependency error to the coach. |
| Helper cannot find ADB | Install **platform-tools** in section 4. Check `local.properties`; the helper also checks ANDROID_HOME, ANDROID_SDK_ROOT, common SDK folders, and PATH. No PATH edits are needed for our normal setup. |
| Helper connection refused/timed out | Check Hub power and the exact Wi-Fi network. Reconnect to Hub Wi-Fi and rerun. Ask the coach whether the default address changed. Do not use the Hub's pairing mode. |
| ADB **unauthorized** | Ask a coach to approve debugging access on the Hub using the appropriate USB/REV setup. Do not reset the Hub or revoke all debugging authorizations yourself. |
| ADB **offline** | Wait for the Hub to finish starting, then rerun. If it stays offline, have a coach inspect that device's ADB connection. The helper deliberately leaves existing connections alone. |
| Helper blocked by school policy / window closes before a result | Open the `.bat` from File Explorer, not the `.ps1`. Check both files exist. Ask school IT/coach if PowerShell is blocked; do not disable security controls. |
| Run installs but controller does not open | Verify **Launch: Default Activity**, wait for installation to complete, and check the Driver Station. Ask a coach before changing app permissions/settings. |
| TeleOp missing from Driver Station | Confirm the upload succeeded to the intended Hub. Wait for the controller to reconnect; refresh/reopen the TeleOp list. Look for **BioBuzz StarterBot Teleop**, not Drawing.kt. Confirm `@TeleOp` is present, `@Disabled` is absent, and there are no build errors. |
| INIT reports missing hardware | The Hub's robot configuration must contain `left_drive`, `right_drive`, `intake`, `launcher`, `windmill`, `left_intake_servo`, and `right_intake_servo` with the correct device types. Ask the coach; do not rename devices to hide the error. |

## Coach notes and verification boundary

The repair preserves motor directions, hardware names, buttons, speeds, and the existing disabled
launcher-speed interlock. **The feeder can still run without the launcher reaching its minimum speed.**
Review that behavior separately before operating the launcher; this environment repair does not enable the interlock.

On the repaired laptop, the debug APK and dependency compatibility checks passed. The helper's
hardware-free tests are in `tools/test-connect-control-hub.ps1`; run with
`powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/test-connect-control-hub.ps1`.
This does not contact the robot. The batch launcher uses a process-only execution-policy option;
it does not change Windows' saved policy or request administrator access.

**Physical Wi-Fi connection, installation, controller restart, and Driver Station discovery still require
the coach's real Hub test.** A new laptop must also complete its own first-build check.
