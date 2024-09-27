part of 'selected_new_device_cubit.dart';

/// Base class for the states of the SelectedNewDeviceCubit.
@immutable
sealed class SelectedNewDeviceState {}

/// Represents the initial state when no device is selected.
final class SelectedNewDeviceInitial extends SelectedNewDeviceState {}

/// Represents the state when a device has been selected.
final class SelectedNewDeviceSelected extends SelectedNewDeviceState {
  /// The selected device, represented as a Map of its properties.
  final Map<String, dynamic> selectedDevice;

  /// Creates a new instance of [SelectedNewDeviceSelected].
  ///
  /// [selectedDevice] is a Map containing the details of the selected device.
  SelectedNewDeviceSelected(this.selectedDevice);
}
