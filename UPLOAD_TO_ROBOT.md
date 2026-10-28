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
5. **Look for SUCCESS: Control Hub ready.** Note the address/serial it shows. Press any key
   to close the helper. If it fails, use the help below before clicking Run.
6. **Return to IntelliJ.** Wait a few seconds for the device list to refresh.
7. **Select TeamCode** in the top Run dropdown. In the device dropdown, select the Hub
   matching the helper's address/serial. Do not choose **Current File** or the assemble-only task.
8. **Click the green Run triangle.** This builds, installs, and opens the Robot Controller app.
9. **Wait for installation to finish.** The Driver Station may briefly disconnect while the app
   restarts. Do not switch networks or turn off the Hub during the upload.
10. **On the Driver Station, select your TeleOp.** This project's program is
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
- **Build/download error:** Return to normal Wi-Fi, sync/build successfully, then repeat from step 3.
- **TeleOp missing:** Confirm installation finished on the correct Hub. Wait for the Driver
  Station to reconnect and reopen its TeleOp list. Do not start another program by guessing.

More help: [Windows setup and troubleshooting](WINDOWS_FTC_SETUP_GUIDE.md).
Missing the toolbar button? Add it once using **section 9** of the setup guide, or use File Explorer.
The coach must complete the first physical deployment test; local builds alone do not verify it.
