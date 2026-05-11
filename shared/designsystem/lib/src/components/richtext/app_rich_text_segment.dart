import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

sealed class AppRichTextSegment {
  const AppRichTextSegment();

  const factory AppRichTextSegment.text(
    String text, {
    TextStyle? style,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) = _TextSegment;

  const factory AppRichTextSegment.widget(
    Widget widget, {
    PlaceholderAlignment alignment,
    TextBaseline? baseline,
  }) = _WidgetSegment;

  InlineSpan toInlineSpan();
}

final class _TextSegment extends AppRichTextSegment {
  final String text;
  final TextStyle? style;
  final GestureRecognizer? recognizer;
  final String? semanticsLabel;

  const _TextSegment(
    this.text, {
    this.style,
    this.recognizer,
    this.semanticsLabel,
  });

  @override
  InlineSpan toInlineSpan() => TextSpan(
    text: text,
    style: style,
    recognizer: recognizer,
    semanticsLabel: semanticsLabel,
  );
}

final class _WidgetSegment extends AppRichTextSegment {
  final Widget widget;
  final PlaceholderAlignment alignment;
  final TextBaseline? baseline;

  const _WidgetSegment(
    this.widget, {
    this.alignment = PlaceholderAlignment.middle,
    this.baseline,
  });

  @override
  InlineSpan toInlineSpan() => WidgetSpan(
    child: widget,
    alignment: alignment,
    baseline: baseline,
  );
}
