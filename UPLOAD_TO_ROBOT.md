# Upload to the robot
**Stripes & Circuits — FTC Team 36701**

First time on this laptop? Finish [Windows setup](WINDOWS_FTC_SETUP_GUIDE.md) first.

1. **Turn on the REV Control Hub.** Keep the robot supported safely and clear of people.
2. **Stay on normal Wi-Fi to finish editing and building.** Save your code and sync Gradle
   in IntelliJ. In its PowerShell Terminal at the project root, run:

   ```powershell
   .\gradlew.bat :TeamCode:assembleDebug
   .\gradlew.bat --offline :TeamCode:assembleDebug
   ```

   Both must say **BUILD SUCCESSFUL** before you leave normal Wi-Fi. The second command
   checks that building works without internet. Save/open this guide locally before switching
   networks; Codex will be unavailable. The complete Robot Controller APK is
   `TeamCode\build\outputs\apk\debug\TeamCode-debug.apk`.
   In IntelliJ's Gradle window, enable **Toggle Offline Mode** after the successful builds
   so the Run button can build using downloaded libraries on robot Wi-Fi.
3. **Join the Control Hub's Wi-Fi** from the Windows taskbar network menu. Use the team's
   network name/password from the coach. “No internet” is normal.
4. **Click Connect Control Hub in IntelliJ's top toolbar** (the small round, dotted icon near
   **master**). Or open **File Explorer > project folder > tools** and double-click **connect-control-hub.bat**.
5. **Look for SUCCESS: Control Hub ready.** Note the address/serial. Press any key; if the
   helper window stays open, close its **X**. ADB stays connected. Stop if the helper failed.
6. **Return to IntelliJ.** Wait a few seconds for the device list to refresh.
7. **Select TeamCode** in the top Run dropdown. In the device dropdown, select the Hub
   matching the helper's address/serial. Do not choose **Current File** or the assemble-only task.
8. **Click the green Run triangle or circular Rerun arrow beside TeamCode.** Both upload and
   open the controller app. The bug icon is Debug; the dotted button only connects ADB.
9. **Wait for installation to finish.** The Driver Station may briefly disconnect while the app
   restarts. Do not switch networks or turn off the Hub during the upload.
10. **On the separate Driver Hub or Android phone**, open **FTC Driver Station**, then its
    **TeleOp dropdown** (not in IntelliJ). This project's program is
    **BioBuzz StarterBot Teleop Custom**, group **StarterBot**. In the Driver Station menu,
    open **Self Inspect** and check that both Driver Station and Robot Controller show **11.2**.
    Confirm there is no `@OpModeRegistrar` error. Road Runner tuning programs should
    still appear in the `quickstart` group. For tuning, open `http://192.168.43.1:8080/dash`
    on the laptop while on robot Wi-Fi; check that configuration entries such as
    `AngularRampLogger` and `ManualFeedforwardTuner` are present. Do not change tuning
    values or start a tuner just to check the page. Ask the coach before INIT/START.
    **AutoPath** is in the Autonomous list, but its existing Pedro follower factory returns
    `null`; do not INIT/START it until the team configures that factory for the robot.
11. **Reconnect the laptop to normal Wi-Fi afterward** for GitHub updates and downloads.
    Turn off Gradle's **Toggle Offline Mode** before the next dependency change or sync.

**Two connections are needed:** Windows Wi-Fi joins the robot's network; the helper connects
**ADB**, which lets IntelliJ upload. The helper does not upload or switch Wi-Fi. Students do
not need to type ADB commands or use the Hub's pairing mode.

## If something goes wrong

- **No Devices / helper failed:** Check Hub power and the exact Wi-Fi network, then rerun the
  helper. The normal address is **192.168.43.1:5555**; ask the coach if the network changed.
- **ADB missing, unauthorized, or offline:** Show the helper's message to the coach.
- **Current file is not runnable:** Select **TeamCode**, then click Run again.
- **Different signature / uninstall prompt:** Click **Cancel** and ask the coach. Do not erase the app yourself.
- **Build/download error:** Return to normal Wi-Fi, sync/build successfully, then repeat from step 3.
- **Need to install the already-built APK:** With the Hub connected, IntelliJ's PowerShell
  Terminal can install the exact file without rebuilding. For this laptop's SDK location:

  ```powershell
  & 'C:\Android\Sdk\platform-tools\adb.exe' -s '192.168.43.1:5555' install -r '.\TeamCode\build\outputs\apk\debug\TeamCode-debug.apk'
  ```

  Use the address printed by the connection helper if different. Wait for **Success**,
  then restart the Robot Controller from the Driver Station menu if it does not reconnect.
  This command preserves app data when signatures match. For a signature error, stop and
  ask the coach; do not uninstall or clear storage. On other laptops, use the SDK path
  in `local.properties` instead of `C:\Android\Sdk`.
- **TeleOp missing:** Confirm installation finished on the correct Hub. Wait for the Driver
  Station to reconnect and reopen its TeleOp list. Do not start another program by guessing.

More help: [Windows setup and troubleshooting](WINDOWS_FTC_SETUP_GUIDE.md).
Missing the toolbar button? Add it once using **section 9** of the setup guide, or use File Explorer.
USB and wireless app installation/launch are verified; Driver Station discovery remains to be checked.
