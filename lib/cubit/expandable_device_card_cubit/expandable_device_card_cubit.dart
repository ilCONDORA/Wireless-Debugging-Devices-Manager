import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'expandable_device_card_state.dart';

/// ExpandableDeviceCardCubit manages the state of the expandable card.
class ExpandableDeviceCardCubit extends Cubit<ExpandableDeviceCardState> {
  /// Creates a ExpandableDeviceCardCubit with the initial state set to ExpandableDeviceCardNotExpanded.
  ExpandableDeviceCardCubit() : super(ExpandableDeviceCardCollapsed());

  /// Method that emits the ExpandableDeviceCardExpanded state to indicate that the card is expanded.
  void expandCard() {
    emit(ExpandableDeviceCardExpanded());
  }

  /// Method that emits the ExpandableDeviceCardNotExpanded state to indicate that the card is collapsed.
  void collapseCard() {
    emit(ExpandableDeviceCardCollapsed());
  }
}
