import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:ui/src/widgets/primitives/richtext/app_rich_text_segment.dart';

class AppRichText extends StatelessWidget {
  final List<AppRichTextSegment> segments;

  // Layout / behavior
  final TextAlign textAlign;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final bool softWrap;
  final bool selectable;

  // Advanced hooks
  final TextDirection? textDirection;

  const AppRichText({
    super.key,
    required this.segments,
    this.textAlign = TextAlign.start,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.softWrap = true,
    this.selectable = false,
    this.textDirection,
  });

  factory AppRichText.highlight({
    Key? key,
    required String text,
    required Pattern pattern,
    required TextStyle highlightStyle,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool selectable = false,
  }) {
    final spans = <AppRichTextSegment>[];
    final regex = pattern is RegExp ? pattern : RegExp(RegExp.escape(pattern.toString()));
    var start = 0;
    for (final m in regex.allMatches(text)) {
      if (m.start > start) {
        spans.add(AppRichTextSegment.text(text.substring(start, m.start)));
      }
      spans.add(
        AppRichTextSegment.text(
          text.substring(m.start, m.end),
          style: highlightStyle,
        ),
      );
      start = m.end;
    }
    if (start < text.length) {
      spans.add(AppRichTextSegment.text(text.substring(start)));
    }
    return AppRichText(
      key: key,
      segments: spans,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      selectable: selectable,
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = context.typography.captionSmall.merge(style);
    final children = segments.map((s) => s.toInlineSpan()).toList();

    if (selectable) {
      return SelectableText.rich(
        TextSpan(style: base, children: children),
        textAlign: textAlign,
        maxLines: maxLines,
      );
    }

    return RichText(
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(style: base, children: children),
    );
  }
}
