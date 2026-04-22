import 'package:flutter/material.dart';

/// For Material widgets that take an `elevation: double` parameter
/// (Card, Material, AppBar, FAB), use [AppElevations] instead.
class AppShadows {
  AppShadows._();

  /// No shadow. Use for flat surfaces or to explicitly clear a shadow.
  static const List<BoxShadow> none = [];

  /// Resting — cards at rest, list items, subtle lift off the background.
  /// Barely-there depth that implies "this is its own surface" without
  /// drawing attention.
  static const List<BoxShadow> resting = [
    BoxShadow(
      color: Color(0x0F000000), // black @ 6%
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Raised — default for elevated surfaces like cards and small popovers.
  /// The "if in doubt" shadow for anything that should look lifted.
  static const List<BoxShadow> raised = [
    BoxShadow(
      color: Color(0x14000000), // black @ 8%
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
    BoxShadow(
      color: Color(0x0A000000), // black @ 4%
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Floating — dropdowns, menus, tooltips, popovers that appear above
  /// other content temporarily. More depth than [raised] to signal
  /// "this is detached from the layout flow."
  static const List<BoxShadow> floating = [
    BoxShadow(
      color: Color(0x19000000), // black @ 10%
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  /// Lifted — modals, dialogs, bottom sheets. Strong depth that signals
  /// "this sits above the entire screen and demands attention."
  static const List<BoxShadow> lifted = [
    BoxShadow(
      color: Color(0x1F000000), // black @ 12%
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  /// Overlay — rare, for full-screen overlays and hero elements that
  /// need to feel like they're floating over everything else. Use
  /// sparingly; at this depth the shadow becomes a focal element itself.
  static const List<BoxShadow> overlay = [
    BoxShadow(
      color: Color(0x26000000), // black @ 15%
      offset: Offset(0, 16),
      blurRadius: 32,
    ),
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
  ];
}
