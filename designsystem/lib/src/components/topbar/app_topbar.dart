import 'package:designsystem/src/components/text/app_text.dart';
import 'package:designsystem/src/components/topbar/app_topbar_theme.dart';
import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  final bool showBackButton;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  // Style overrides (null = use theme)
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final double? toolbarHeight;

  // Behavior
  final VoidCallback? onBackPressed;

  /// Spacing applied between actions and on the trailing edge.
  /// Uses logical (start/end) insets so RTL works correctly.
  final double actionSpacing;
  final double trailingPadding;

  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.bottom,
    this.showBackButton = true,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.toolbarHeight,
    this.onBackPressed,
    this.actionSpacing = 4,
    this.trailingPadding = 8,
  }) : assert(
         title == null || titleWidget == null,
         'Provide either title or titleWidget, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTopBarTheme>()!;
    final bg = backgroundColor ?? theme.backgroundColor;
    final fg = foregroundColor ?? theme.foregroundColor;
    final elev = elevation ?? theme.elevation;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elev,
      scrolledUnderElevation: theme.scrolledUnderElevation,
      shadowColor: theme.shadowColor,
      surfaceTintColor: theme.surfaceTintColor,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false, // we handle leading ourselves
      title: _buildTitle(fg),
      leading: _buildLeading(context, fg),
      actions: _buildActions(),
      bottom: bottom,
      iconTheme: IconThemeData(color: fg),
      actionsIconTheme: IconThemeData(color: fg),
    );
  }

  Widget? _buildTitle(Color foregroundColor) {
    if (titleWidget != null) return titleWidget;
    if (title != null) {
      return AppText.titleMedium(title!, color: foregroundColor);
    }
    return null;
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;
    if (!automaticallyImplyLeading) return null;
    if (!showBackButton) return null;
    if (!Navigator.of(context).canPop()) return null;

    // BackButton is platform-adaptive and handles RTL correctly.
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: 20,
        color: foregroundColor,
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  List<Widget>? _buildActions() {
    if (actions == null || actions!.isEmpty) return null;

    final spaced = <Widget>[];
    for (var i = 0; i < actions!.length; i++) {
      spaced.add(actions![i]);
      if (i < actions!.length - 1) {
        spaced.add(SizedBox(width: actionSpacing));
      }
    }
    // Trailing edge padding (RTL-safe via Padding + EdgeInsetsDirectional).
    spaced.add(SizedBox(width: trailingPadding));
    return spaced;
  }

  @override
  Size get preferredSize {
    final toolbar = toolbarHeight ?? kToolbarHeight;
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(toolbar + bottomHeight);
  }
}
