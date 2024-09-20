import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/models/device_model.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/bloc/devices_bloc/devices_bloc.dart';

/// A widget that displays detailed information about a device in a card format.
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
            onEdit: () {
              // TODO: Implement IP address editing functionality
            },
            isConnected: device.isConnected,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            label: condorLocalization.l10n.customNameLabel,
            value: device.customName,
            onEdit: () {
              // TODO: Implement custom name editing functionality
            },
            isConnected: device.isConnected,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            label: condorLocalization.l10n.serialNumberLabel,
            value: device.serialNumber,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            label: condorLocalization.l10n.modelLabel,
            value: device.model,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            label: condorLocalization.l10n.manufacturerLabel,
            value: device.manufacturer,
          ),
          const SizedBox(height: 14),
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
  Widget _buildTextField({
    required String label,
    required String value,
    VoidCallback? onEdit,
    bool isConnected = false,
  }) {
    return Row(
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
    );
  }
}

/// A widget that displays action buttons for a device.
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
            onPressed: () {
              // TODO: Implement TCP/IP functionality
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
}

/// Builds the connect button with appropriate visibility for the loading indicator.
class ConnectButton extends StatefulWidget {
  const ConnectButton({
    super.key,
    required this.device,
  });

  final DeviceModel device;

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  bool itsDoingSomething = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Visibility(
            visible: itsDoingSomething,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),
        ),
        const SizedBox(width: 14),
        ElevatedButton(
          onPressed: widget.device.isConnected
              ? null
              : () async {
                  setState(() {
                    itsDoingSomething = true;
                  });
                  final isSuccess = await condorAdbCommands.connectToDevice(
                      completeIpAddress: widget.device.completeIpAddress);
                  if (isSuccess && context.mounted) {
                    context.read<DevicesBloc>().add(
                        UpdateDeviceConnectionStatus(
                            serialNumber: widget.device.serialNumber,
                            isConnected: true));
                  }
                  setState(() {
                    itsDoingSomething = false;
                  });
                },
          child: Text(condorLocalization.l10n.connectDeviceButton),
        ),
      ],
    );
  }
}

/// Builds the disconnect button with appropriate visibility for the loading indicator.
class DisconnectButton extends StatefulWidget {
  const DisconnectButton({
    super.key,
    required this.device,
  });

  final DeviceModel device;

  @override
  State<DisconnectButton> createState() => _DisconnectButtonState();
}

class _DisconnectButtonState extends State<DisconnectButton> {
  bool itsDoingSomething = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Visibility(
            visible: itsDoingSomething,
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),
        ),
        const SizedBox(width: 14),
        ElevatedButton(
          onPressed: widget.device.isConnected
              ? () async {
                  setState(() {
                    itsDoingSomething = true;
                  });
                  await condorAdbCommands
                      .disconnectFromDevice(
                          completeIpAddress: widget.device.completeIpAddress)
                      .then((_) {
                    if (context.mounted) {
                      context.read<DevicesBloc>().add(
                          UpdateDeviceConnectionStatus(
                              serialNumber: widget.device.serialNumber,
                              isConnected: false));
                    }
                  });
                  setState(() {
                    itsDoingSomething = false;
                  });
                }
              : null,
          child: Text(condorLocalization.l10n.disconnectDeviceButton),
        ),
      ],
    );
  }
}
