import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  final ImageSource _source;
  final String? _path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final String? package;
  final AssetBundle? bundle;
  final Map<String, String>? headers;
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
  final ImageShape shape;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext, Widget, int?, bool)? frameBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

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
    this.shape = ImageShape.rectangle,
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderWidth = 0.0,
    this.padding,
  }) : _source = ImageSource.asset,
       _path = path,
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
    this.shape = ImageShape.rectangle,
    this.borderRadius = 8.0,
    this.borderColor,
    this.borderWidth = 0.0,
    this.padding,
  }) : _source = ImageSource.network,
       _path = url,
       package = null,
       bundle = null;

  Widget _defaultFrameBuilder(
    BuildContext _,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (wasSynchronouslyLoaded) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: child,
    );
  }

  Widget _defaultLoadingBuilder(
    BuildContext _,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
      ),
    );
  }

  Widget _defaultErrorBuilder(
    BuildContext _,
    Object _,
    StackTrace? _,
  ) {
    return const Center(child: Icon(Icons.broken_image_outlined));
  }

  Widget _applyShape(Widget child) {
    final border = borderColor != null ? Border.all(color: borderColor!, width: borderWidth) : null;

    return switch (shape) {
      ImageShape.rectangle => Container(
        padding: padding ?? EdgeInsets.zero,
        decoration: borderColor != null ? BoxDecoration(border: border) : null,
        child: child,
      ),
      ImageShape.circle => Container(
        padding: padding ?? EdgeInsets.zero,
        decoration: borderColor != null ? BoxDecoration(shape: BoxShape.circle, border: border) : null,
        child: ClipOval(child: child),
      ),
      ImageShape.rounded => Container(
        padding: padding ?? EdgeInsets.zero,
        decoration: borderColor != null
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: border,
              )
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final path = _path!;
    final effectiveFrameBuilder = frameBuilder ?? _defaultFrameBuilder;
    final effectiveLoadingBuilder = loadingBuilder ?? _defaultLoadingBuilder;
    final effectiveErrorBuilder = errorBuilder ?? _defaultErrorBuilder;
    return _applyShape(switch (_source) {
      ImageSource.asset =>
        path.endsWith('.svg')
            ? SvgPicture.asset(
                path,
                width: width,
                height: height,
                fit: fit ?? BoxFit.contain,
                alignment: alignment,
                semanticsLabel: semanticLabel,
                package: package,
                bundle: bundle,
                colorFilter: color != null ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn) : null,
                excludeFromSemantics: excludeFromSemantics,
              )
            : Image.asset(
                path,
                width: width,
                height: height,
                fit: fit,
                color: color,
                colorBlendMode: colorBlendMode,
                alignment: alignment,
                semanticLabel: semanticLabel,
                package: package,
                bundle: bundle,
                frameBuilder: effectiveFrameBuilder,
                errorBuilder: effectiveErrorBuilder,
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
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        semanticLabel: semanticLabel,
        headers: headers,
        frameBuilder: effectiveFrameBuilder,
        loadingBuilder: effectiveLoadingBuilder,
        errorBuilder: effectiveErrorBuilder,
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
    });
  }
}

enum ImageSource { asset, network }

enum ImageShape { rectangle, circle, rounded }
