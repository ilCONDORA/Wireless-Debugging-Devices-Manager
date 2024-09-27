import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/cubit/selected_new_device_cubit/selected_new_device_cubit.dart';

/// A dialog that allows the user to select and add a new device.
class CondorAddDeviceDialog extends StatelessWidget {
  /// Creates a [CondorAddDeviceDialog].
  const CondorAddDeviceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectedNewDeviceCubit(),
      child: Builder(
        builder: (context) => _buildDialog(context),
      ),
    );
  }

  /// Builds the main structure of the dialog.
  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: Text(condorLocalization.l10n.addDeviceButton),
      content: _buildDialogContent(context),
      actions: _buildDialogActions(context),
    );
  }

  /// Builds the content of the dialog, including the device list.
  Widget _buildDialogContent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.6,
      child: FutureBuilder(
        future: condorAdbCommands.getConnectedDevicesList(),
        builder: _buildDeviceList,
      ),
    );
  }

  /// Builds the list of devices or shows appropriate messages based on the FutureBuilder state.
  Widget _buildDeviceList(BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoadingIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return _buildDeviceListView(context, snapshot.data!);
    } else {
      return Text(condorLocalization.l10n.noDevicesFound);
    }
  }

  /// Builds a loading indicator for when the device list is being fetched.
  Widget _buildLoadingIndicator() {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  /// Builds a scrollable list view of devices.
  Widget _buildDeviceListView(
      BuildContext context, List<Map<String, dynamic>> devices) {
    context.read<SelectedNewDeviceCubit>().setSelectedDevice(devices[0]);
    ScrollController controller = ScrollController();
    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Colors.grey.shade600),
        ),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        controller: controller,
        child: ListView.builder(
          padding: const EdgeInsets.only(right: 22),
          shrinkWrap: true,
          controller: controller,
          itemCount: devices.length,
          itemBuilder: (context, index) =>
              _buildDeviceListItem(context, devices[index]),
        ),
      ),
    );
  }

  /// Builds a single item in the device list.
  Widget _buildDeviceListItem(
      BuildContext context, Map<String, dynamic> device) {
    return BlocBuilder<SelectedNewDeviceCubit, SelectedNewDeviceState>(
      builder: (context, state) {
        return RadioListTile(
          value: device,
          groupValue:
              state is SelectedNewDeviceSelected ? state.selectedDevice : null,
          onChanged: (value) {
            context.read<SelectedNewDeviceCubit>().setSelectedDevice(value!);
          },
          title: _buildDeviceInfo(device),
        );
      },
    );
  }

  /// Builds the detailed information for a single device.
  Widget _buildDeviceInfo(Map<String, dynamic> device) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_formatIpAddressLabel(device['ip address'])),
        Text(
            '${condorLocalization.l10n.serialNumberLabel}: ${device['serial number']}'),
        Text('${condorLocalization.l10n.modelLabel}: ${device['model']}'),
        Text(
            '${condorLocalization.l10n.manufacturerLabel}: ${device['manufacturer']}'),
        Text(
            '${condorLocalization.l10n.androidVersionLabel}: ${device['android version']}'),
      ],
    );
  }

  /// Formats the IP address label.
  String _formatIpAddressLabel(String ipAddress) {
    String originalString = condorLocalization.l10n.completeIpAddressLabel;
    List<String> words = originalString.split(' ');
    words.removeAt(0);
    String correctString = words.join(' ');
    return '$correctString: $ipAddress';
  }

  /// Builds the action buttons for the dialog.
  List<Widget> _buildDialogActions(BuildContext context) {
    return [
      ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(condorLocalization.l10n.cancelButton),
      ),
      ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.green),
        ),
        onPressed: () => _handleSaveButtonPressed(context),
        child: Text(condorLocalization.l10n.saveButton),
      ),
    ];
  }

  /// Handles the press of the save button.
  void _handleSaveButtonPressed(BuildContext context) {
    final selectedDevice =
        context.read<SelectedNewDeviceCubit>().getSelectedDevice();
    print(selectedDevice);
  }
}
