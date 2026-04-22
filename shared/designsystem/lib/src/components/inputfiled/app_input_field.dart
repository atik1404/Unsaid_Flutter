import 'package:designsystem/src/components/icon/app_icon.dart';
import 'package:designsystem/src/components/inputfiled/inputfield.dart';
import 'package:designsystem/src/components/typography/app_typography_theme.dart';
import 'package:flutter/material.dart';

enum _InputVisualState { disabled, error, focused, defaultState }

class AppInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;

  final AppInputFieldVariant variant;
  final AppInputFieldSize size;
  final AppInputFieldShape shape;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Widget? prefix;
  final Widget? suffix;
  final AppIcon? prefixIcon;
  final AppIcon? suffixIcon;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  const AppInputField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.variant = AppInputFieldVariant.outline,
    this.size = AppInputFieldSize.md,
    this.shape = AppInputFieldShape.rounded,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  bool get _hasError =>
      widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppInputFieldTheme>()!;
    final typography = Theme.of(context).extension<AppTypographyTheme>()!;
    final colors = theme.colors;
    final spec = AppInputFieldSizeSpec.of(widget.size);
    final state = _resolveState();

    // Resolve typography
    final textStyle = typography.byIntent(spec.textIntent);
    final labelStyle = typography.byIntent(spec.labelIntent);
    final helperStyle = typography.byIntent(spec.helperIntent);

    // Resolve state-dependent colors
    final iconColor = _iconColorFor(state, colors);
    final textColor = _textColorFor(state, colors);
    final labelColor = _labelColorFor(state, colors);
    final floatingLabelColor = _floatingLabelColorFor(state, colors);
    final fillColor = _fillColorFor(state, colors);

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      cursorColor: colors.cursor,
      style: textStyle.copyWith(color: textColor),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefix: widget.prefix,
        suffix: widget.suffix,
        prefixIcon: _wrapIcon(widget.prefixIcon, iconColor, spec.iconSize),
        suffixIcon: _wrapIcon(widget.suffixIcon, iconColor, spec.iconSize),
        filled: widget.variant == AppInputFieldVariant.filled,
        fillColor: fillColor,
        isDense: widget.size == AppInputFieldSize.sm,
        contentPadding: spec.contentPadding,
        labelStyle: labelStyle.copyWith(color: labelColor),
        floatingLabelStyle: labelStyle.copyWith(color: floatingLabelColor),
        hintStyle: textStyle.copyWith(color: colors.placeholder),
        helperStyle: helperStyle.copyWith(color: colors.helper),
        errorStyle: helperStyle.copyWith(color: colors.helperError),
        border: _buildBorder(
          colors.borderDefault,
          theme.defaultBorderWidth,
          spec,
        ),
        enabledBorder: _buildBorder(
          colors.borderDefault,
          theme.defaultBorderWidth,
          spec,
        ),
        focusedBorder: _buildBorder(
          colors.borderFocused,
          theme.focusedBorderWidth,
          spec,
        ),
        errorBorder: _buildBorder(
          colors.borderError,
          theme.defaultBorderWidth,
          spec,
        ),
        focusedErrorBorder: _buildBorder(
          colors.borderErrorFocused,
          theme.focusedBorderWidth,
          spec,
        ),
        disabledBorder: _buildBorder(
          colors.borderDisabled,
          theme.defaultBorderWidth,
          spec,
        ),
      ),
    );
  }

  _InputVisualState _resolveState() {
    if (!widget.enabled) return _InputVisualState.disabled;
    if (_hasError) return _InputVisualState.error;
    if (_isFocused) return _InputVisualState.focused;
    return _InputVisualState.defaultState;
  }

  Color _iconColorFor(_InputVisualState state, AppInputFieldColors c) =>
      switch (state) {
        _InputVisualState.disabled => c.iconDisabled,
        _InputVisualState.error => c.iconError,
        _InputVisualState.focused => c.iconFocused,
        _InputVisualState.defaultState => c.icon,
      };

  Color _textColorFor(_InputVisualState state, AppInputFieldColors c) =>
      switch (state) {
        _InputVisualState.disabled => c.textDisabled,
        _ => c.text,
      };

  Color _labelColorFor(_InputVisualState state, AppInputFieldColors c) =>
      switch (state) {
        _InputVisualState.disabled => c.labelDisabled,
        _ => c.label,
      };

  Color _floatingLabelColorFor(
    _InputVisualState state,
    AppInputFieldColors c,
  ) => switch (state) {
    _InputVisualState.disabled => c.labelDisabled,
    _InputVisualState.error => c.labelError,
    _ => c.labelFocused,
  };

  Color _fillColorFor(_InputVisualState state, AppInputFieldColors c) =>
      switch (state) {
        _InputVisualState.disabled => c.fillDisabled,
        _ => c.fill,
      };

  Widget? _wrapIcon(Widget? icon, Color color, double size) {
    if (icon == null) return null;
    return IconTheme.merge(
      data: IconThemeData(color: color, size: size),
      child: icon,
    );
  }

  InputBorder _buildBorder(
    Color color,
    double width,
    AppInputFieldSizeSpec spec,
  ) {
    final side = BorderSide(color: color, width: width);
    return switch (widget.variant) {
      AppInputFieldVariant.underline => UnderlineInputBorder(borderSide: side),
      AppInputFieldVariant.outline ||
      AppInputFieldVariant.filled => OutlineInputBorder(
        borderRadius: _radiusFor(spec),
        borderSide: side,
      ),
    };
  }

  BorderRadius _radiusFor(AppInputFieldSizeSpec spec) => switch (widget.shape) {
    AppInputFieldShape.rounded => BorderRadius.circular(spec.borderRadius),
    AppInputFieldShape.pill => BorderRadius.circular(999),
    AppInputFieldShape.sharp => BorderRadius.zero,
  };
}
