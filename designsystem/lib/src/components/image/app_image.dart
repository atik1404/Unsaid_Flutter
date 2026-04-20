import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final ImageSource _source;
  final String? _path;
  final Uint8List? _bytes;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final String? package;
  final AssetBundle? bundle;
  final Map<String, String>? headers;
  final Widget Function(BuildContext, Widget, int?, bool)? frameBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final int? cacheWidth;
  final int? cacheHeight;
  final double scale;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final bool excludeFromSemantics;

  const AppImage.asset(
    String path, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.package,
    this.bundle,
    this.frameBuilder,
    this.errorBuilder,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.excludeFromSemantics = false,
  }) : _source = ImageSource.asset,
       _path = path,
       _bytes = null,
       headers = null,
       loadingBuilder = null;

  const AppImage.network(
    String url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.headers,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.excludeFromSemantics = false,
  }) : _source = ImageSource.network,
       _path = url,
       _bytes = null,
       package = null,
       bundle = null;

  const AppImage.file(
    String filePath, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.frameBuilder,
    this.errorBuilder,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.excludeFromSemantics = false,
  }) : _source = ImageSource.file,
       _path = filePath,
       _bytes = null,
       package = null,
       bundle = null,
       headers = null,
       loadingBuilder = null;

  const AppImage.memory(
    Uint8List bytes, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.frameBuilder,
    this.errorBuilder,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.excludeFromSemantics = false,
  }) : _source = ImageSource.memory,
       _bytes = bytes,
       _path = null,
       package = null,
       bundle = null,
       headers = null,
       loadingBuilder = null;

  @override
  Widget build(BuildContext context) {
    return switch (_source) {
      ImageSource.asset => Image.asset(
        _path!,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        package: package,
        bundle: bundle,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        scale: scale,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        excludeFromSemantics: excludeFromSemantics,
      ),
      ImageSource.network => Image.network(
        _path!,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        headers: headers,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        scale: scale,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        excludeFromSemantics: excludeFromSemantics,
      ),
      ImageSource.file => Image.file(
        File(_path!),
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        scale: scale,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        excludeFromSemantics: excludeFromSemantics,
      ),
      ImageSource.memory => Image.memory(
        _bytes!,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        scale: scale,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        excludeFromSemantics: excludeFromSemantics,
      ),
    };
  }
}

enum ImageSource { asset, network, file, memory }
