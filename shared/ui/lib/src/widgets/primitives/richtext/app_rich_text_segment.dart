import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppRichTextSegment {
  final String? text;
  final TextStyle? style;
  final GestureRecognizer? recognizer;
  final Widget? widget;
  final PlaceholderAlignment alignment;
  final TextBaseline? baseline;

  const AppRichTextSegment.text(
    this.text, {
    this.style,
    this.recognizer,
    this.widget,
    this.alignment = PlaceholderAlignment.baseline,
    this.baseline = TextBaseline.alphabetic,
  });

  const AppRichTextSegment.widget(
    this.widget, {
    this.alignment = PlaceholderAlignment.middle,
    this.baseline,
    this.text,
    this.style,
    this.recognizer,
  });

  InlineSpan toInlineSpan() {
    if (widget != null) {
      return WidgetSpan(
        child: widget!,
        alignment: alignment,
        baseline: baseline,
      );
    }
    return TextSpan(text: text ?? '', style: style, recognizer: recognizer);
  }
}
