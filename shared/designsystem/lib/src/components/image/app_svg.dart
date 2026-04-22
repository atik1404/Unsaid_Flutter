import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvg extends StatelessWidget {
  final SvgSource _source;
  final String? _path;
  final Uint8List? _bytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BlendMode colorBlendMode;
  final AlignmentGeometry alignment;
  final String? package;
  final String? semanticsLabel;
  final bool allowDrawingOutsideViewBox;
  final Widget Function(BuildContext)? placeholderBuilder;
  final AssetBundle? bundle;
  final Map<String, String>? headers;
  final Clip clipBehavior;

  const AppSvg.asset(
    String path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.alignment = Alignment.center,
    this.package,
    this.semanticsLabel,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.bundle,
    this.clipBehavior = Clip.hardEdge,
  }) : _source = SvgSource.asset,
       _path = path,
       _bytes = null,
       headers = null;

  const AppSvg.network(
    String url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.headers,
    this.clipBehavior = Clip.hardEdge,
  }) : _source = SvgSource.network,
       _path = url,
       _bytes = null,
       package = null,
       bundle = null;

  const AppSvg.string(
    String svgString, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.clipBehavior = Clip.hardEdge,
  }) : _source = SvgSource.string,
       _path = svgString,
       _bytes = null,
       package = null,
       bundle = null,
       headers = null;

  const AppSvg.memory(
    Uint8List bytes, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.alignment = Alignment.center,
    this.semanticsLabel,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.clipBehavior = Clip.hardEdge,
  }) : _source = SvgSource.memory,
       _bytes = bytes,
       _path = null,
       package = null,
       bundle = null,
       headers = null;

  @override
  Widget build(BuildContext context) {
    final colorFilter = color != null ? ColorFilter.mode(color!, colorBlendMode) : null;

    return switch (_source) {
      SvgSource.asset => SvgPicture.asset(
        _path!,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        alignment: alignment,
        package: package,
        semanticsLabel: semanticsLabel,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: placeholderBuilder,
        bundle: bundle,
        clipBehavior: clipBehavior,
      ),
      SvgSource.network => SvgPicture.network(
        _path!,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: placeholderBuilder,
        headers: headers,
        clipBehavior: clipBehavior,
      ),
      SvgSource.string => SvgPicture.string(
        _path!,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: placeholderBuilder,
        clipBehavior: clipBehavior,
      ),
      SvgSource.memory => SvgPicture.memory(
        _bytes!,
        width: width,
        height: height,
        fit: fit,
        colorFilter: colorFilter,
        alignment: alignment,
        semanticsLabel: semanticsLabel,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder: placeholderBuilder,
        clipBehavior: clipBehavior,
      ),
    };
  }
}

enum SvgSource { asset, network, string, memory }
