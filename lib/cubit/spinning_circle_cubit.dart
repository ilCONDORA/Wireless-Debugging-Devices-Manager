import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'spinning_circle_state.dart';

/// SpinningCircleCubit manages the state of the spinning circle.
class SpinningCircleCubit extends Cubit<SpinningCircleState> {
  /// Creates a SpinningCircleCubit with the initial state set to SpinningCircleStopped.
  SpinningCircleCubit() : super(SpinningCircleStopped());

  /// Method that emits the SpinningCircleSpinning state to indicate that the circle is spinning.
  void startSpinning() {
    emit(SpinningCircleSpinning());
  }

  /// Method that emits the SpinningCircleStopped state to indicate that the circle has stopped spinning.
  void stopSpinning() {
    emit(SpinningCircleStopped());
  }
}
