import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wireless_debugging_devices_manager/models/device_model.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(DevicesInitial()) {
    on<DevicesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
