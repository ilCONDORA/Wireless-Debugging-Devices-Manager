part of 'devices_bloc.dart';

/// Base state for managing the application's devices.
/// It holds an instance of `DevicesModel`, which contains the current devices.
@immutable
sealed class DevicesState {
  final List<DeviceModel> devices;

  /// Constructor that initializes the state with the provided [devices].
  const DevicesState(this.devices);
}

/// Represents the initial state of the application devices.
/// This state is used when the app is first launched or when the devices are not yet loaded.
final class DevicesInitial extends DevicesState {
  /// Creates an initial state with 1 device in the list of devices.
  DevicesInitial() : super([DeviceModel(
    ipAddress: '192.168.1.1',
    port: 5555,
    customName: 'Samsung Galaxy S22+',
    serialNumber: 'XJYPL678QWE',
    model: 'SM_S906B',
    manufacturer: 'Samsung',
    androidVersion: '14',
    isConnected: false,
  )]);
}

/// Represents a state where the application devices have changed.
/// This state is emitted when the user updates any of the devices.
class DevicesChanged extends DevicesState {
  /// Constructor that accepts a new [devices] to represent the updated devices.
  const DevicesChanged(super.devices);
}
