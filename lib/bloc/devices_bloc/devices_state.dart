part of 'devices_bloc.dart';

/// Base state class for managing the application's devices.
/// All device-related states should extend this class.
@immutable
sealed class DevicesState {
  final List<DeviceModel> devices;

  /// Creates a DevicesState with the specified list of devices.
  ///
  /// The [devices] parameter represents the current list of devices in the application.
  const DevicesState(this.devices);
}

/// Represents the initial state of the application's devices.
///
/// This state is used when the app is first launched or when no persisted state is available.
/// It initializes with a single example device for demonstration purposes.
final class DevicesInitial extends DevicesState {
  /// Creates the initial state with a pre-defined example device.
  DevicesInitial()
      : super([
          DeviceModel(
            completeIpAddress: '192.168.1.1:5555',
            customName: 'Samsung Galaxy S22+',
            serialNumber: 'XJYPL678QWE',
            model: 'SM_S906B',
            manufacturer: 'Samsung',
            androidVersion: '14',
            isConnected: false,
          )
        ]);
}

/// Represents a state where the application's devices have been modified.
///
/// This state is emitted when devices are added, updated, or removed from the list.
class DevicesChanged extends DevicesState {
  /// Creates a DevicesChanged state with the updated list of devices.
  ///
  /// The [devices] parameter represents the new, modified list of devices.
  const DevicesChanged(super.devices);
}
