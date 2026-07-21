import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

class InlineIconLabel extends StatelessWidget {
  final Widget text;
  final String? label;

  final EdgeInsetsGeometry? padding;

  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final double? horizontalGap;

  /// Layout controls
  final Axis direction;
  final bool wrap;
  final double? runSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final Clip clipBehavior;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapIcon;

  const InlineIconLabel({
    super.key,
    required this.text,
    this.label,
    this.padding,
    this.leadingWidget,
    this.trailingWidget,
    this.horizontalGap,
    this.direction = Axis.horizontal,
    this.wrap = false,
    this.runSpacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.clipBehavior = Clip.none,
    this.onTap,
    this.onTapIcon,
  });

  @override
  Widget build(BuildContext context) {
    final widget = text;

    // Direction-aware start/end resolution (RTL swaps leading/trailing)
    // final isRtl = Directionality.of(context) == TextDirection.rtl;
    // final startIconSpec = isRtl ? trailing : leading;
    // final endIconSpec   = isRtl ? leading  : trailing;

    final resolvedWidget = (!wrap && direction == Axis.horizontal)
        ? Flexible(child: widget)
        : widget;
    final resolvedLeading = leadingWidget;
    final resolvedTrailing = trailingWidget;

    final children = <Widget>[
      if (resolvedLeading != null)
        _maybeInk(child: resolvedLeading, onTap: onTapIcon),
      resolvedWidget,
      if (resolvedTrailing != null)
        _maybeInk(child: resolvedTrailing, onTap: onTapIcon),
    ];

    if (wrap) {
      final widget = Wrap(
        direction: direction,
        alignment: _wrapAlignmentFrom(mainAxisAlignment),
        crossAxisAlignment: _wrapCrossFrom(crossAxisAlignment),
        spacing: horizontalGap ?? AppSpacing.zero,
        runSpacing: runSpacing ?? AppSpacing.zero,
        children: children,
      );

      return _maybeInk(
        child: Padding(padding: padding ?? EdgeInsets.zero, child: widget),
        onTap: onTap,
      );
    } else if (direction == Axis.horizontal) {
      final widget = Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        spacing: horizontalGap ?? AppSpacing.zero,
        children: children,
      );
      return _maybeInk(
        child: Padding(padding: padding ?? EdgeInsets.zero, child: widget),
        onTap: onTap,
      );
    } else {
      final widget = Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        spacing: horizontalGap ?? AppSpacing.zero,
        children: children,
      );
      return _maybeInk(
        child: Padding(padding: padding ?? EdgeInsets.zero, child: widget),
        onTap: onTap,
      );
    }
  }

  Widget _maybeInk({
    required Widget child,
    required VoidCallback? onTap,
  }) {
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      clipBehavior: clipBehavior,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }

  // Helpers to map Row alignment to Wrap
  WrapAlignment _wrapAlignmentFrom(MainAxisAlignment m) {
    switch (m) {
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
      case MainAxisAlignment.start:
        return WrapAlignment.start;
    }
  }

  WrapCrossAlignment _wrapCrossFrom(CrossAxisAlignment c) {
    switch (c) {
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      case CrossAxisAlignment.start:
      default:
        return WrapCrossAlignment.start;
    }
  }
}
