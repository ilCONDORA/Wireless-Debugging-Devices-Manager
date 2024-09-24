import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/cubit/spinning_circle_cubit.dart';
import 'package:wireless_debugging_devices_manager/models/device_model.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/bloc/devices_bloc/devices_bloc.dart';

/// A widget that displays detailed information about a device in a card format.
///
/// This widget is responsible for creating the overall structure of the device card,
/// including the device information and action buttons.
class CondorDeviceCard extends StatelessWidget {
  /// Creates a CondorDeviceCard.
  ///
  /// The [device] parameter must not be null and contains the data to be displayed.
  const CondorDeviceCard({super.key, required this.device});

  /// The device model containing the data to be displayed in the card.
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 555,
      child: Card(
        color: Colors.grey.shade400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 11,
          ),
          child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
            // Rebuild only when the locale changes
            buildWhen: (previous, current) =>
                previous.appSettingsModel.locale !=
                current.appSettingsModel.locale,
            builder: (context, state) {
              return BlocBuilder<DevicesBloc, DevicesState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      CondorDeviceInfos(device: device),
                      CondorColumnButtons(device: device),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A widget that displays the detailed information of a device.
///
/// This widget creates a column of text fields displaying various device properties
/// such as complete IP address, custom name, serial number, model, manufacturer, and Android version.
class CondorDeviceInfos extends StatelessWidget {
  /// Creates a CondorDeviceInfos widget.
  ///
  /// The [device] parameter must not be null and contains the data to be displayed.
  const CondorDeviceInfos({
    super.key,
    required this.device,
  });

  /// The device model containing the data to be displayed.
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 333,
      child: Column(
        children: [
          _buildTextField(
            label: condorLocalization.l10n.completeIpAddressLabel,
            value: device.completeIpAddress,
            onEdit: () => _showEditDialog(
              context: context,
              title: condorLocalization.l10n.editIpAddressTitle,
              initialValue: device.completeIpAddress,
              onSave: (newValue) {
                context.read<DevicesBloc>().add(
                      UpdateDeviceIpAddress(
                        serialNumber: device.serialNumber,
                        newCompleteIpAddress: newValue,
                      ),
                    );
              },
            ),
            isConnected: device.isConnected,
            addUpperSpacing: false,
          ),
          _buildTextField(
            label: condorLocalization.l10n.customNameLabel,
            value: device.customName,
            onEdit: () => _showEditDialog(
              context: context,
              title: condorLocalization.l10n.editCustomNameTitle,
              initialValue: device.customName,
              onSave: (newValue) {
                context.read<DevicesBloc>().add(
                      UpdateDeviceName(
                        serialNumber: device.serialNumber,
                        newName: newValue,
                      ),
                    );
              },
            ),
            isConnected: device.isConnected,
          ),
          _buildTextField(
            label: condorLocalization.l10n.serialNumberLabel,
            value: device.serialNumber,
          ),
          _buildTextField(
            label: condorLocalization.l10n.modelLabel,
            value: device.model,
          ),
          _buildTextField(
            label: condorLocalization.l10n.manufacturerLabel,
            value: device.manufacturer,
          ),
          _buildTextField(
            label: condorLocalization.l10n.androidVersionLabel,
            value: device.androidVersion,
          ),
        ],
      ),
    );
  }

  /// Builds a text field with the given label and value.
  ///
  /// If [onEdit] is provided, an edit button will be displayed next to the field.
  /// [isConnected] determines if the edit button should be enabled.
  /// [addUpperSpacing] adds vertical spacing above the field if true.
  Widget _buildTextField({
    required String label,
    required String value,
    VoidCallback? onEdit,
    bool isConnected = false,
    bool addUpperSpacing = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (addUpperSpacing) const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: value),
                decoration: InputDecoration(
                  labelText: label,
                ),
              ),
            ),
            if (onEdit != null && isConnected == false) ...[
              const SizedBox(width: 6),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Shows an edit dialog with the given title and initial value.
  ///
  /// This function creates and displays an AlertDialog for editing a device property.
  /// [onSave] is called with the new value when the user confirms the edit.
  Future<void> _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: initialValue),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(condorLocalization.l10n.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(condorLocalization.l10n.saveButton),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/// A widget that displays action buttons for a device.
///
/// This widget creates a column of buttons for various device actions
/// such as connect, disconnect, run tcpip, mirror screen, and delete.
class CondorColumnButtons extends StatelessWidget {
  /// Creates a CondorColumnButtons widget.
  ///
  /// The [device] parameter must not be null and is used to determine the state of the buttons.
  const CondorColumnButtons({
    super.key,
    required this.device,
  });

  /// The device model used to determine the state of the buttons.
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 36,
        children: [
          ConnectButton(device: device),
          DisconnectButton(device: device),
          ElevatedButton(
            onPressed: device.isConnected
                ? null
                : () {
                    _showTcpipDialog(context, device);
                  },
            child: Text(condorLocalization.l10n.runTcpipButton),
          ),
          ElevatedButton(
            onPressed: device.isConnected
                ? () {
                    condorAdbCommands.mirrorScreen(
                        completeIPAddress: device.completeIpAddress);
                  }
                : null,
            child: Text(condorLocalization.l10n.mirrorScreenButton),
          ),
          IconButton(
            onPressed: device.isConnected
                ? null
                : () {
                    context
                        .read<DevicesBloc>()
                        .add(RemoveDevice(serialNumber: device.serialNumber));
                  },
            icon: Icon(
              Icons.delete,
              color: device.isConnected ? Colors.grey : Colors.red.shade600,
              size: 44,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog for running tcpip command on the device.
  ///
  /// This function extracts the current port from the device's IP address,
  /// allows the user to edit it, and then runs the tcpip command with the new port.
  Future<void> _showTcpipDialog(
      BuildContext context, DeviceModel device) async {
    // Regular expression to extract the port number from the IP address
    final portRegex = RegExp(r':(\d+)$');

    // Attempt to match the regex against the device's IP address
    final match = portRegex.firstMatch(device.completeIpAddress);

    // If a match is found, use the captured group (port number), otherwise use '5555' as default
    final initialPort = match != null ? match.group(1) : '5555';

    final controller = TextEditingController(text: initialPort);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(condorLocalization.l10n.runTcpipDialogTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: initialPort),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(condorLocalization.l10n.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(condorLocalization.l10n.runTcpipButton),
              onPressed: () async {
                final int port = int.tryParse(controller.text) ?? 5555;
                final isSuccess = await condorAdbCommands.runTcpip(
                  serialNumber: device.serialNumber,
                  tcpipPort: port,
                );
                if (isSuccess && context.mounted) {
                  final newIpAddress = device.completeIpAddress
                      .replaceFirst(RegExp(r':\d+$'), ':$port');
                  context.read<DevicesBloc>().add(
                        UpdateDeviceIpAddress(
                          serialNumber: device.serialNumber,
                          newCompleteIpAddress: newIpAddress,
                        ),
                      );
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// Builds the connect button with appropriate visibility for the loading indicator.
///
/// This widget uses a cubit to manage the state of the spinning circle.
class ConnectButton extends StatelessWidget {
  const ConnectButton({
    super.key,
    required this.device,
  });

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /// SpinningCircleCubit manages the state of the spinning circle.
      create: (context) => SpinningCircleCubit(),
      child: BlocBuilder<SpinningCircleCubit, SpinningCircleState>(
        builder: (context, state) {
          return Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Visibility(
                  /// Only show the loading indicator if the state is SpinningCircleSpinning.
                  visible: state is SpinningCircleSpinning,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: device.isConnected
                    ? null
                    : () async {
                        /// Create a reference to the SpinningCircleCubit so that the context can be accessed easily.
                        final spinningCircleCubit =
                            context.read<SpinningCircleCubit>();

                        /// Invoke the startSpinning method, which will emit the SpinningCircleSpinning state.
                        spinningCircleCubit.startSpinning();

                        final isSuccess =
                            await condorAdbCommands.connectToDevice(
                                completeIpAddress: device.completeIpAddress);

                        if (isSuccess && context.mounted) {
                          context.read<DevicesBloc>().add(
                                UpdateDeviceConnectionStatus(
                                    serialNumber: device.serialNumber,
                                    isConnected: true),
                              );
                        }

                        /// Invoke the stopSpinning method, which will emit the SpinningCircleStopped state.
                        spinningCircleCubit.stopSpinning();
                      },
                child: Text(condorLocalization.l10n.connectDeviceButton),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Builds the disconnect button with appropriate visibility for the loading indicator.
///
/// This widget uses a cubit to manage the state of the spinning circle.
class DisconnectButton extends StatelessWidget {
  const DisconnectButton({
    super.key,
    required this.device,
  });

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /// SpinningCircleCubit manages the state of the spinning circle.
      create: (context) => SpinningCircleCubit(),
      child: BlocBuilder<SpinningCircleCubit, SpinningCircleState>(
        builder: (context, state) {
          return Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Visibility(
                  /// Only show the loading indicator if the state is SpinningCircleSpinning.
                  visible: state is SpinningCircleSpinning,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: device.isConnected
                    ? () async {
                        /// Create a reference to the SpinningCircleCubit so that the context can be accessed easily.
                        final spinningCircleCubit =
                            context.read<SpinningCircleCubit>();

                        /// Invoke the startSpinning method, which will emit the SpinningCircleSpinning state.
                        spinningCircleCubit.startSpinning();

                        await condorAdbCommands
                            .disconnectFromDevice(
                                completeIpAddress: device.completeIpAddress)
                            .then(
                          (_) {
                            if (context.mounted) {
                              context.read<DevicesBloc>().add(
                                    UpdateDeviceConnectionStatus(
                                        serialNumber: device.serialNumber,
                                        isConnected: false),
                                  );
                            }
                          },
                        );

                        /// Invoke the stopSpinning method, which will emit the SpinningCircleStopped state.
                        spinningCircleCubit.stopSpinning();
                      }
                    : null,
                child: Text(condorLocalization.l10n.disconnectDeviceButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
