import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forgot_password/src/state/forgot_password_cubit.dart';
import 'package:forgot_password/src/state/forgot_password_state.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:navigation/navigation.dart';
import 'package:ui/ui.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => ForgotPasswordCubit(), child: const _ForgotPasswordScreenView());
  }
}

class _ForgotPasswordScreenView extends StatefulWidget {
  const _ForgotPasswordScreenView();

  @override
  State<_ForgotPasswordScreenView> createState() => _ForgotPasswordScreenViewState();
}

class _ForgotPasswordScreenViewState extends State<_ForgotPasswordScreenView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(enableGradientBackground: true, body: _buildForgotPasswordUi(context));
  }

  Widget _buildForgotPasswordUi(BuildContext context) {
    final pagePadding = EdgeInsets.all(AppSpacing.s24.r);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: pagePadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - pagePadding.vertical),
            child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  final message = state.errorMessage == 'empty_phone' ? context.l10n.forgot_password_error_empty_phone : state.errorMessage!;
                  AppToast.toast(message: message, toastType: ToastType.error);
                } else if (state.isSuccess) {
                  AppToast.toast(message: context.l10n.forgot_password_success, toastType: ToastType.success);
                  context.pushNamed(AppRouteName.otpVerificationScreen, extra: state.phone.trim());
                }
              },
              child: _buildContent(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final gap = SizedBox(height: AppSpacing.s12.h);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(context),
        gap,
        gap,
        AppText.bodySmall(context.l10n.forgot_password_label_phone, textWeight: AppTextWeight.light, color: context.appColors.white),
        SizedBox(height: AppSpacing.s4.h),
        _buildPhoneInput(context),
        gap,
        gap,
        _buildSendOtpButton(context),
        gap,
        _buildBackToLoginLink(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppImage.asset(AppDrawables.logoTransparent, width: 100.w, height: 100.h),
        SizedBox(height: AppSpacing.s16.h),
        AppText.titleLarge(context.l10n.forgot_password_title, textWeight: AppTextWeight.extraBold),
        SizedBox(height: AppSpacing.s8.h),
        AppText.bodySmall(context.l10n.forgot_password_subtitle, textAlign: TextAlign.center, textWeight: AppTextWeight.light, color: context.appColors.white),
      ],
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return AppInputField(
      hint: context.l10n.forgot_password_hint_phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      variant: AppInputFieldVariant.filledOpt,
      maxLength: 11,
      onChanged: (value) => context.read<ForgotPasswordCubit>().updatePhone(value),
    );
  }

  Widget _buildSendOtpButton(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return AppFilledButton.text(context.l10n.forgot_password_button, isLoading: state.isSubmitting, onPressed: () => context.read<ForgotPasswordCubit>().sendOtp());
      },
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return Align(
      child: AppTextButton(
        context.l10n.forgot_password_back_to_login,
        onPressed: () => context.pop(),
        style: const AppTextButtonStyle(intent: AppButtonIntent.secondary()),
      ),
    );
  }
}
