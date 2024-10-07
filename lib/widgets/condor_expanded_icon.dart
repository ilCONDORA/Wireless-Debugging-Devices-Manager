// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget representing a rotating expand/collapse button. The icon rotates
/// 180 degrees when pressed, then reverts the animation on a second press.
/// The underlying icon is [Icons.expand_more].
///
/// The expand icon does not include a semantic label for accessibility. In
/// order to be accessible it should be combined with a label using
/// [MergeSemantics]. This is done automatically by the [ExpansionPanel] widget.
///
/// See [IconButton] for a more general implementation of a pressable button
/// with an icon.
///
/// See also:
///
///  * https://material.io/design/iconography/system-icons.html

/// Condor added
enum CondorIconDirection { vertical, horizontal, oblique1, oblique2 }

class CondorExpandIcon extends StatefulWidget {
  /// Creates an [CondorExpandIcon] with the given padding, and a callback that is
  /// triggered when the icon is pressed.
  const CondorExpandIcon({
    super.key,
    this.isExpanded = false,
    this.size = 24.0,
    required this.onPressed,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
    this.disabledColor,
    this.expandedColor,
    this.splashColor,
    this.highlightColor,
    this.iconDirection = CondorIconDirection.vertical, // Condor added
    this.tooltip, // Condor added
  });

  /// Whether the icon is in an expanded state.
  ///
  /// Rebuilding the widget with a different [isExpanded] value will trigger
  /// the animation, but will not trigger the [onPressed] callback.
  final bool isExpanded;

  /// The size of the icon.
  ///
  /// Defaults to 24.
  final double size;

  /// The callback triggered when the icon is pressed and the state changes
  /// between expanded and collapsed. The value passed to the current state.
  ///
  /// If this is set to null, the button will be disabled.
  final ValueChanged<bool>? onPressed;

  /// The padding around the icon. The entire padded icon will react to input
  /// gestures.
  ///
  /// Defaults to a padding of 8 on all sides.
  final EdgeInsetsGeometry padding;

  /// {@template flutter.material.ExpandIcon.color}
  /// The color of the icon.
  ///
  /// Defaults to [Colors.black54] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white60] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  /// {@endtemplate}
  final Color? color;

  /// The color of the icon when it is disabled,
  /// i.e. if [onPressed] is null.
  ///
  /// Defaults to [Colors.black38] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white38] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? disabledColor;

  /// The color of the icon when the icon is expanded.
  ///
  /// Defaults to [Colors.black54] when the theme's
  /// [ThemeData.brightness] is [Brightness.light] and to
  /// [Colors.white] when it is [Brightness.dark]. This adheres to the
  /// Material Design specifications for [icons](https://material.io/design/iconography/system-icons.html#color)
  /// and for [dark theme](https://material.io/design/color/dark-theme.html#ui-application)
  final Color? expandedColor;

  /// Defines the splash color of the IconButton.
  ///
  /// If [ThemeData.useMaterial3] is true, this field will be ignored,
  /// as [IconButton.splashColor] will be ignored, and you should use
  /// [highlightColor] instead.
  ///
  /// Defaults to [ThemeData.splashColor].
  final Color? splashColor;

  /// Defines the highlight color of the IconButton.
  ///
  /// Defaults to [ThemeData.highlightColor].
  final Color? highlightColor;

  /// Condor added
  final CondorIconDirection iconDirection;

  /// Condor added
  final String? tooltip;

  @override
  State<CondorExpandIcon> createState() => _CondorExpandIconState();
}

class _CondorExpandIconState extends State<CondorExpandIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  /// Condor added
  late double _iconBegin;

  /// Condor added
  late double _iconEnd;

  late Animatable<double> _iconTurnTween;

  /// Condor modified
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);

    /// Condor added
    switch (widget.iconDirection) {
      case CondorIconDirection.vertical:
        _iconBegin = 0.0;
        _iconEnd = 0.5;
        break;
      case CondorIconDirection.horizontal:
        _iconBegin = 0.25;
        _iconEnd = 0.75;
        break;
      case CondorIconDirection.oblique1:
        _iconBegin = 0.875;
        _iconEnd = 0.375;
        break;
      case CondorIconDirection.oblique2:
        _iconBegin = 0.125;
        _iconEnd = 0.625;
        break;
    }

    /// Condor modified
    _iconTurnTween = Tween<double>(begin: _iconBegin, end: _iconEnd)
        .chain(CurveTween(curve: Curves.fastOutSlowIn));

    _iconTurns = _controller.drive(_iconTurnTween);
    // If the widget is initially expanded, rotate the icon without animating it.
    if (widget.isExpanded) {
      _controller.value = math.pi;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CondorExpandIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handlePressed() {
    widget.onPressed?.call(widget.isExpanded);
  }

  /// Default icon colors and opacities for when [Theme.brightness] is set to
  /// [Brightness.light] are based on the
  /// [Material Design system icon specifications](https://material.io/design/iconography/system-icons.html#color).
  /// Icon colors and opacities for [Brightness.dark] are based on the
  /// [Material Design dark theme specifications](https://material.io/design/color/dark-theme.html#ui-application)
  Color get _iconColor {
    if (widget.isExpanded && widget.expandedColor != null) {
      return widget.expandedColor!;
    }

    if (widget.color != null) {
      return widget.color!;
    }

    return switch (Theme.of(context).brightness) {
      Brightness.light => Colors.black54,
      Brightness.dark => Colors.white60,
    };
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String onTapHint = widget.isExpanded
        ? localizations.expandedIconTapHint
        : localizations.collapsedIconTapHint;

    return Semantics(
      onTapHint: widget.onPressed == null ? null : onTapHint,
      child: IconButton(
        tooltip: widget.tooltip, // Condor added
        padding: widget.padding,
        iconSize: widget.size,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor,
        color: _iconColor,
        disabledColor: widget.disabledColor,
        onPressed: widget.onPressed == null ? null : _handlePressed,
        icon: RotationTransition(
          turns: _iconTurns,
          child: const Icon(Icons.keyboard_double_arrow_down_rounded), /// Condor modified
        ),
      ),
    );
  }
}
