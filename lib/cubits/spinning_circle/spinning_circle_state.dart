part of 'spinning_circle_cubit.dart';

/// Abstract class representing the possible states of the spinning circle.
@immutable
sealed class SpinningCircleState {}

/// Represents the state when the spinning circle is not in motion.
final class SpinningCircleStopped extends SpinningCircleState {}

/// Represents the state when the spinning circle is in motion.
final class SpinningCircleSpinning extends SpinningCircleState {}
