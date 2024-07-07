# PurpurMC-Auto-Updater-for-Windows

This PowerShell script automates the process of checking for the latest build of PurpurMC for Minecraft (version 1.21), downloading the latest build if it's newer than the current versions in the specified directory, and managing older builds by keeping only the latest 3 builds.

## Features

- **API Integration**: Connects to the PurpurMC API to check for the latest build version.
- **Automated Downloads**: Downloads the latest build if it's newer than existing builds in the "Purpur Downloads" directory.
- **File Management**: Ensures only the latest 3 builds are kept in the "Purpur Downloads" directory, deleting older builds automatically.
- **Logging**: Logs key actions and events such as the latest build check, download success or failure, file copying, and deletion of old builds.
- **Easy to Use**: Simple script setup with customizable parameters.

## How It Works

1. **Check Latest Build**: The script queries the PurpurMC API to retrieve the latest build number for Minecraft (currently version 1.21).
2. **Compare Builds**: It compares the latest build number with the builds available in the "Purpur Downloads" directory.
3. **Download New Build**: If the latest build is newer, the script downloads the new `.jar` file and renames it to `purpur.jar` in the script's directory.
4. **Manage Old Builds**: The script retains only the latest 3 builds in the "Purpur Downloads" directory, deleting older builds to free up space.
5. **Log Actions**: All actions are logged in a `purpur_download_log.txt` file for easy tracking and debugging.

## Folder Structure

- The script should be placed in the same directory as your `purpur.jar` file.
- The main PurpurMC `.jar` file must be named `purpur.jar` for the script to correctly identify and manage it.
- The script will create a subdirectory named `Purpur Downloads` to store and manage the latest builds.

## Usage

1. **Download the Script**: Clone the repository or download the script directly.
2. **First Run**: The first time you run this script, it will not know the version of your `purpur.jar`. In this instance, it will automatically download the latest version and replace your existing version. After this, the script will look for the previously downloaded version and compare it to the latest release (only downloading and replacing if the version is newer).
3. **Auto Running**: To allow the script to check automatically for updates, it is advised that you set a scheduled task (using Windows Task Scheduler) to run this script at your desired interval (e.g., once a day). You will need the server to be offline to allow the script to replace the `.jar`, so you should schedule this during a period where the server is doing other tasks (for example, backup).
4. **Script Logs**: Review the `purpur_download_log.txt` file for detailed logs of the script's actions.

## Requirements

- PowerShell (Windows)
- Internet connection (to access the PurpurMC API and download files)

## Contribution

Feel free to contribute to this project by submitting issues or pull requests. Your feedback and improvements are welcome!

## License

This project is licensed under the MIT License.
