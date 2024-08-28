# Wireless Debugging Devices Manager

**Wireless Debugging Devices Manager** is a software developed in Flutter by **ilCONDORA**.

## Description
This software addresses the inconvenience of having to open the terminal every time to connect devices and start debugging other projects.

By utilizing the powerful `adb` commands, I created this software that allows you to add devices, connect them once to the PC via USB, and then execute the `adb devices -l` command to retrieve the device information and save it in the database. You can also run the `tcpip` command to open a semi-permanent port on your device.

### Key Features
- **Device Management**: Devices are displayed as cards, where you can:
  - Connect/Disconnect the device
  - Execute the `tcpip` command
  - Delete the device
  - Edit the device name and full IP address
- **Kill ADB Server**: A dedicated button to kill the ADB server.

### Software Iterations
- **First Iteration**: [Old-Wireless-Debugging-Devices-Manager](https://github.com/ilCONDORA/Old-Wireless-Debugging-Devices-Manager) which used a JSON file to store device information.
- **Second Iteration**: Never completed due to the complexity of using `provider` and `flutter_secure_storage`.
- **Third Iteration (Current)**: Built using BLoC for state management and storage.

## Requirements
- **ADB (Android Debug Bridge)** installed and configured in your PATH

## Installation
1. Download the correct executable for your machine.