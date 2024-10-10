import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'selected_new_device_state.dart';

/// A Cubit that manages the state of the selected device in the add device dialog.
class SelectedNewDeviceCubit extends Cubit<SelectedNewDeviceState> {
  /// Creates a [SelectedNewDeviceCubit] and sets the initial state.
  SelectedNewDeviceCubit() : super(SelectedNewDeviceInitial());

  /// Selects a new device and updates the state.
  ///
  /// [selectedDevice] is a Map containing the details of the selected device.
  void setSelectedDevice(Map<String, dynamic> selectedDevice) {
    emit(SelectedNewDeviceSelected(selectedDevice));
  }

  /// Retrieves the currently selected device.
  ///
  /// Returns a Map containing the device details currently selected.
  Map<String, dynamic> getSelectedDevice() {
    return (state as SelectedNewDeviceSelected).selectedDevice;
  }
}
