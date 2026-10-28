# Upload to the robot
**Stripes & Circuits — FTC Team 36701**

First time on this laptop? Finish [Windows setup](WINDOWS_FTC_SETUP_GUIDE.md) first.

1. **Turn on the REV Control Hub.** Keep the robot supported safely and clear of people.
2. **Stay on normal Wi-Fi to finish editing and building.** Save your code. In IntelliJ's
   Gradle window, run **TeamCode > Tasks > build > assembleDebug**. Wait for a successful build.
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
    **BioBuzz StarterBot Teleop**, group **StarterBot**. Ask the coach before INIT/START.
11. **Reconnect the laptop to normal Wi-Fi afterward** for GitHub updates and downloads.

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
- **TeleOp missing:** Confirm installation finished on the correct Hub. Wait for the Driver
  Station to reconnect and reopen its TeleOp list. Do not start another program by guessing.

More help: [Windows setup and troubleshooting](WINDOWS_FTC_SETUP_GUIDE.md).
Missing the toolbar button? Add it once using **section 9** of the setup guide, or use File Explorer.
USB and wireless app installation/launch are verified; Driver Station discovery remains to be checked.
