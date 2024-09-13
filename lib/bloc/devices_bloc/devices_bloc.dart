import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wireless_debugging_devices_manager/models/device_model.dart';

part 'devices_event.dart';
part 'devices_state.dart';

/// Manages the state of the application's devices using the BLoC pattern.
/// Utilizes HydratedBloc to automatically persist and restore the state,
/// ensuring that device information is maintained across app restarts.
class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  /// Initializes the bloc with the initial state of the app devices.
  /// Sets up event handlers for various device-related actions.
  DevicesBloc() : super(DevicesInitial()) {
    on<AddDevice>(_onAddDevice);
    on<UpdateDeviceName>(_onUpdateDeviceName);
    on<UpdateDeviceIpAddress>(_onUpdateDeviceIpAddress);
    on<UpdateDeviceConnectionStatus>(_onUpdateDeviceConnectionStatus);
    on<RemoveDevice>(_onRemoveDevice);
    on<DisconnectAllDevices>(_onDisconnectAllDevices); // Nuovo handler
  }

  /// Handles the AddDevice event by adding a new device to the list.
  /// Emits a new state with the updated list of devices.
  void _onAddDevice(AddDevice event, Emitter<DevicesState> emit) {
    final updatedDevices = List<DeviceModel>.from(state.devices)
      ..add(event.device);
    emit(DevicesChanged(updatedDevices));
  }

  /// Handles the UpdateDeviceName event by updating the name of a specific device.
  /// Emits a new state with the updated device information.
  void _onUpdateDeviceName(UpdateDeviceName event, Emitter<DevicesState> emit) {
    final updatedDevices = state.devices.map((device) {
      if (device.serialNumber == event.serialNumber) {
        return device.copyWith(customName: event.newName);
      }
      return device;
    }).toList();
    emit(DevicesChanged(updatedDevices));
  }

  /// Handles the UpdateDeviceIpAddress event by updating the IP address of a specific device.
  /// Emits a new state with the updated device information.
  void _onUpdateDeviceIpAddress(
      UpdateDeviceIpAddress event, Emitter<DevicesState> emit) {
    final updatedDevices = state.devices.map((device) {
      if (device.serialNumber == event.serialNumber) {
        return device.copyWith(completeIpAddress: event.newCompleteIpAddress);
      }
      return device;
    }).toList();
    emit(DevicesChanged(updatedDevices));
  }

  /// Handles the UpdateDeviceConnectionStatus event by updating the connection status of a specific device.
  /// Emits a new state with the updated device information.
  void _onUpdateDeviceConnectionStatus(
      UpdateDeviceConnectionStatus event, Emitter<DevicesState> emit) {
    final updatedDevices = state.devices.map((device) {
      if (device.serialNumber == event.serialNumber) {
        return device.copyWith(isConnected: event.isConnected);
      }
      return device;
    }).toList();
    emit(DevicesChanged(updatedDevices));
  }

  /// Handles the RemoveDevice event by removing a specific device from the list.
  /// Emits a new state with the updated list of devices.
  void _onRemoveDevice(RemoveDevice event, Emitter<DevicesState> emit) {
    final updatedDevices = state.devices
        .where((device) => device.serialNumber != event.serialNumber)
        .toList();
    emit(DevicesChanged(updatedDevices));
  }

  /// Handles the DisconnectAllDevices event by setting all devices' connection status to false.
  /// Emits a new state with all devices disconnected.
  void _onDisconnectAllDevices(
      DisconnectAllDevices event, Emitter<DevicesState> emit) {
    final updatedDevices = state.devices
        .map((device) => device.copyWith(isConnected: false))
        .toList();
    emit(DevicesChanged(updatedDevices));
  }

  /// Converts a JSON object into an instance of [DevicesState].
  ///
  /// Called by `HydratedBloc` when reopening the app to restore the saved state
  /// from a persisted instance. If the JSON is valid, it returns a [DevicesChanged]
  /// state with the restored devices. If the conversion fails, it returns the
  /// [DevicesInitial] state, indicating no valid data to restore.
  @override
  DevicesState? fromJson(Map<String, dynamic> json) {
    try {
      final devices = (json['devices'] as List)
          .map((deviceJson) => DeviceModel.fromJson(deviceJson))
          .toList();
      return DevicesChanged(devices);
    } catch (_) {
      return DevicesInitial();
    }
  }

  /// Converts the current [DevicesState] into a JSON object for persistence.
  ///
  /// Called by `HydratedBloc` to save the current state when changes occur.
  /// If the state is [DevicesChanged], it serializes the devices into JSON.
  /// Returns null for [DevicesInitial], indicating no state to persist.
  @override
  Map<String, dynamic>? toJson(DevicesState state) {
    if (state is DevicesChanged) {
      return {
        'devices': state.devices.map((device) => device.toJson()).toList(),
      };
    }
    return null;
  }
}
