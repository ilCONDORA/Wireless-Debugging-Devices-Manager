part of 'expandable_device_card_cubit.dart';

/// Abstract class representing the possible states of the expandable card.
@immutable
sealed class ExpandableDeviceCardState {}

/// Represents the state when the expandable card is collapsed.
final class ExpandableDeviceCardCollapsed extends ExpandableDeviceCardState {}

/// Represents the state when the expandable card is expanded.
final class ExpandableDeviceCardExpanded extends ExpandableDeviceCardState {}
