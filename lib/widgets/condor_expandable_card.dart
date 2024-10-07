import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/devices_bloc/devices_bloc.dart';
import 'package:wireless_debugging_devices_manager/cubit/expandable_device_card_cubit/expandable_device_card_cubit.dart';
import 'package:wireless_debugging_devices_manager/cubit/spinning_circle_cubit/spinning_circle_cubit.dart';
import 'package:wireless_debugging_devices_manager/models/device_model.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_expanded_icon.dart';

/// A custom expandable card widget that animates between a normal and an expanded state.
///
/// This widget uses [AnimatedCrossFade] to smoothly transition between two states: normal and expanded.
/// It takes [singleDevice] as a required parameter, which represents the device information to be displayed in the card.
class CondorExpandableCard extends StatelessWidget {
  const CondorExpandableCard({
    super.key,
    this.paddingOfContent = const EdgeInsets.all(0),
    required this.singleDevice,
    this.animationDuration = const Duration(milliseconds: 300),
    this.iconDirection = CondorIconDirection.vertical,
  });

  /// The device information to be displayed in the card.
  final DeviceModel singleDevice;

  /// Padding of the content of the card.
  final EdgeInsetsGeometry paddingOfContent;

  /// Duration of the expansion/collapse animation.
  final Duration animationDuration;

  /// Direction of the expand/collapse icon.
  final CondorIconDirection iconDirection;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade400,
      child: BlocProvider(
        create: (context) => ExpandableDeviceCardCubit(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BlocBuilder<ExpandableDeviceCardCubit, ExpandableDeviceCardState>(
              builder: (contextOfExpandableCard, stateOfExpandableCard) {
                return BlocBuilder<AppSettingsBloc, AppSettingsState>(
                  /// Rebuild only when the locale changes
                  buildWhen: (previous, current) =>
                      previous.appSettingsModel.locale !=
                      current.appSettingsModel.locale,
                  builder: (contextOfAppSettings, stateOfAppSettings) {
                    return BlocBuilder<DevicesBloc, DevicesState>(
                      builder: (contextOfDevices, stateOfDevices) {
                        /// AnimatedCrossFade handles the smooth transition between normal and expanded states
                        return AnimatedCrossFade(
                          /// Determines which child to show based on the expanded state
                          crossFadeState: stateOfExpandableCard
                                  is ExpandableDeviceCardExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: animationDuration,
                          alignment: Alignment.topLeft,
                          sizeCurve: Curves.easeIn,

                          /// The first child is the normal (collapsed) state
                          firstChild: Padding(
                            padding: paddingOfContent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 333,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _buildIPCustomNameInfos(
                                        contextOfDevices),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ConnectButton(device: singleDevice),
                                    DisconnectButton(device: singleDevice),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // The second child is the expanded state, including both normal and expanded content
                          secondChild: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: paddingOfContent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 333,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ..._buildIPCustomNameInfos(
                                              contextOfDevices),
                                          _buildTextField(
                                            label: condorLocalization
                                                .l10n.serialNumberLabel,
                                            value: singleDevice.serialNumber,
                                          ),
                                          _buildTextField(
                                            label: condorLocalization
                                                .l10n.modelLabel,
                                            value: singleDevice.model,
                                          ),
                                          _buildTextField(
                                            label: condorLocalization
                                                .l10n.manufacturerLabel,
                                            value: singleDevice.manufacturer,
                                          ),
                                          _buildTextField(
                                            label: condorLocalization
                                                .l10n.androidVersionLabel,
                                            value: singleDevice.androidVersion,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    _buildButtonsColumn(context)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            /// Custom expand/collapse icon, a modified version of [ExpandIcon] from Flutter itself
            BlocBuilder<ExpandableDeviceCardCubit, ExpandableDeviceCardState>(
              builder: (context, state) {
                return CondorExpandIcon(
                  onPressed: (_) {
                    final cubit = context.read<ExpandableDeviceCardCubit>();

                    state is ExpandableDeviceCardExpanded
                        ? cubit.collapseCard()
                        : cubit.expandCard();
                  },
                  isExpanded: state is ExpandableDeviceCardExpanded,
                  iconDirection: iconDirection,
                  tooltip: state is ExpandableDeviceCardExpanded
                      ? condorLocalization.l10n.tooltipCollapse
                      : condorLocalization.l10n.tooltipExpand,
                  size: 30,
                  color: Colors.blue.shade600,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the buttons column.
  Wrap _buildButtonsColumn(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      runAlignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 36,
      children: [
        ConnectButton(device: singleDevice),
        DisconnectButton(device: singleDevice),
        ElevatedButton(
          onPressed: singleDevice.isConnected
              ? null
              : () {
                  _showTcpipDialog(context, singleDevice);
                },
          child: Text(condorLocalization.l10n.runTcpipButton),
        ),
        ElevatedButton(
          onPressed: singleDevice.isConnected
              ? () {
                  condorAdbCommands.mirrorScreen(
                      completeIPAddress: singleDevice.completeIpAddress);
                }
              : null,
          child: Text(condorLocalization.l10n.mirrorScreenButton),
        ),
        IconButton(
          onPressed: singleDevice.isConnected
              ? null
              : () {
                  context.read<DevicesBloc>().add(
                      RemoveDevice(serialNumber: singleDevice.serialNumber));
                },
          icon: Icon(
            Icons.delete,
            color: singleDevice.isConnected ? Colors.grey : Colors.red.shade600,
            size: 44,
          ),
        ),
      ],
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
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: Text(condorLocalization.l10n.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green),
              ),
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

  /// Builds the two information fields for IP address and custom name.
  List<Widget> _buildIPCustomNameInfos(BuildContext context) {
    return [
      _buildTextField(
        label: condorLocalization.l10n.completeIpAddressLabel,
        value: singleDevice.completeIpAddress,
        onEdit: () => _showEditDialog(
          context: context,
          title: condorLocalization.l10n.editIpAddressTitle,
          initialValue: singleDevice.completeIpAddress,
          onSave: (newValue) {
            context.read<DevicesBloc>().add(
                  UpdateDeviceIpAddress(
                    serialNumber: singleDevice.serialNumber,
                    newCompleteIpAddress: newValue,
                  ),
                );
          },
        ),
        isConnected: singleDevice.isConnected,
        addUpperSpacing: false,
      ),
      _buildTextField(
        label: condorLocalization.l10n.customNameLabel,
        value: singleDevice.customName,
        onEdit: () => _showEditDialog(
          context: context,
          title: condorLocalization.l10n.editCustomNameTitle,
          initialValue: singleDevice.customName,
          onSave: (newValue) {
            context.read<DevicesBloc>().add(
                  UpdateDeviceName(
                    serialNumber: singleDevice.serialNumber,
                    newName: newValue,
                  ),
                );
          },
        ),
        isConnected: singleDevice.isConnected,
      ),
    ];
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
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: Text(condorLocalization.l10n.cancelButton),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green),
              ),
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
