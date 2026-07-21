import 'package:designsystem/designsystem.dart';
import 'package:designsystem/src/components/typography/typography.dart';
import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  /// Drives the base typography. Its [AppText.text] value is ignored.
  final AppText textSource;

  final List<AppRichTextSegment> segments;

  // ── layout (mirrors AppText) ──────────────────────────────────────────────
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;

  // ── rich-text extras ──────────────────────────────────────────────────────
  final bool selectable;
  final SelectionChangedCallback? onSelectionChanged;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final StrutStyle? strutStyle;
  final String? semanticsLabel;

  const AppRichText({
    super.key,
    required this.textSource,
    required this.segments,
    this.textAlign,
    this.maxLines,
    this.softWrap,
    this.overflow,
    this.selectable = false,
    this.onSelectionChanged,
    this.textDirection,
    this.textScaler,
    this.strutStyle,
    this.semanticsLabel,
  });

  // ── highlight factory ─────────────────────────────────────────────────────

  /// Splits [text] by [pattern] and wraps every match in [highlightStyle].
  /// Pass the same [textSource] you would use for a plain [AppRichText].
  factory AppRichText.highlight({
    Key? key,
    required String text,
    required Pattern pattern,
    required TextStyle highlightStyle,
    required AppText textSource,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool selectable = false,
    String? semanticsLabel,
  }) {
    final regex = pattern is RegExp
        ? pattern
        : RegExp(RegExp.escape(pattern.toString()));

    final spans = <AppRichTextSegment>[];
    var cursor = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(AppRichTextSegment.text(text.substring(cursor, match.start)));
      }
      spans.add(
        AppRichTextSegment.text(
          text.substring(match.start, match.end),
          style: highlightStyle,
        ),
      );
      cursor = match.end;
    }

    if (cursor < text.length) {
      spans.add(AppRichTextSegment.text(text.substring(cursor)));
    }

    if (spans.isEmpty) {
      spans.add(AppRichTextSegment.text(text));
    }

    return AppRichText(
      key: key,
      textSource: textSource,
      segments: spans,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      selectable: selectable,
      semanticsLabel: semanticsLabel,
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Reuse AppText's own merge logic by reading the same inputs it uses.
    final typography = Theme.of(context).extension<AppTypographyTheme>()!;
    final intentStyle = typography.byIntent(textSource.intent);
    final defaultStyle = DefaultTextStyle.of(context).style;

    final merged = defaultStyle.merge(
      intentStyle.copyWith(
        fontWeight: textSource.textWeight?.fontWeight ?? intentStyle.fontWeight,
      ),
    );

    final effectiveStyle = textSource.color != null
        ? merged.copyWith(color: textSource.color)
        : merged;

    final children = segments.map((s) => s.toInlineSpan()).toList();
    final span = TextSpan(
      style: effectiveStyle,
      children: children,
      semanticsLabel: semanticsLabel,
    );

    if (selectable) {
      assert(
        overflow == null && (softWrap == null || softWrap!),
        'AppRichText: [overflow] and [softWrap] have no effect in selectable '
        'mode. Remove those arguments or set selectable: false.',
      );
      return SelectableText.rich(
        span,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaler: textScaler,
        strutStyle: strutStyle,
        maxLines: maxLines,
        onSelectionChanged: onSelectionChanged,
      );
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      textScaler: textScaler ?? TextScaler.noScaling,
      strutStyle: strutStyle,
      softWrap: softWrap ?? true,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: span,
    );
  }
}
