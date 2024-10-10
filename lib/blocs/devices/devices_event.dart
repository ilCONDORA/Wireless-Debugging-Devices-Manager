part of 'devices_bloc.dart';

/// Base event class for managing the application's devices.
/// All device-related events should extend this class.
@immutable
sealed class DevicesEvent {}

/// Event triggered to add a new device to the list of devices.
class AddDevice extends DevicesEvent {
  final DeviceModel device;

  /// Creates an AddDevice event with the specified device.
  ///
  /// The [device] parameter is required and represents the new device to be added.
  AddDevice({required this.device});
}

/// Event triggered to update the name of a specific device.
class UpdateDeviceName extends DevicesEvent {
  final String serialNumber;
  final String newName;

  /// Creates an UpdateDeviceName event with the specified serial number and new name.
  ///
  /// The [serialNumber] identifies the device to be updated.
  /// The [newName] is the new name to be assigned to the device.
  UpdateDeviceName({required this.serialNumber, required this.newName});
}

/// Event triggered to update the complete IP address of a specific device.
class UpdateDeviceIpAddress extends DevicesEvent {
  final String serialNumber;
  final String newCompleteIpAddress;

  /// Creates an UpdateDeviceIpAddress event with the specified serial number and new IP address.
  ///
  /// The [serialNumber] identifies the device to be updated.
  /// The [newCompleteIpAddress] is the new IP address (including port if applicable) to be assigned.
  UpdateDeviceIpAddress(
      {required this.serialNumber, required this.newCompleteIpAddress});
}

/// Event triggered to update the connection status of a specific device.
class UpdateDeviceConnectionStatus extends DevicesEvent {
  final String serialNumber;
  final bool isConnected;

  /// Creates an UpdateDeviceConnectionStatus event with the specified serial number and connection status.
  ///
  /// The [serialNumber] identifies the device to be updated.
  /// The [isConnected] indicates whether the device is connected (true) or disconnected (false).
  UpdateDeviceConnectionStatus(
      {required this.serialNumber, required this.isConnected});
}

/// Event triggered to remove a specific device from the list of devices.
class RemoveDevice extends DevicesEvent {
  final String serialNumber;

  /// Creates a RemoveDevice event with the specified serial number.
  ///
  /// The [serialNumber] identifies the device to be removed from the list.
  RemoveDevice({required this.serialNumber});
}

/// Event triggered to disconnect all devices in the list.
///
/// This event doesn't require any parameters as it applies a global action to all devices.
/// When handled, it sets the connection status of all devices to false.
class DisconnectAllDevices extends DevicesEvent {}

/// Event triggered to reorder devices in the list.
class ReorderDevices extends DevicesEvent {
  final int oldIndex;
  final int newIndex;

  /// Creates a ReorderDevices event with the specified old and new indices.
  ///
  /// The [oldIndex] specifies the old index of the device to be reordered.
  /// The [newIndex] specifies the new index of the device to be reordered.
  ReorderDevices(this.oldIndex, this.newIndex);
}
