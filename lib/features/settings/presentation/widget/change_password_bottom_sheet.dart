import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/settings_bottom_sheet_header.dart';

Future<void> showChangePasswordBottomSheet({
  required BuildContext context,
  required TextEditingController currentPasswordController,
  required TextEditingController newPasswordController,
  required TextEditingController confirmPasswordController,
  required Future<void> Function() onSubmit,
  bool isLoading = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ChangePasswordBottomSheet(
        currentPasswordController: currentPasswordController,
        newPasswordController: newPasswordController,
        confirmPasswordController: confirmPasswordController,
        onSubmit: onSubmit,
        isLoading: isLoading,
      );
    },
  );
}

class ChangePasswordBottomSheet extends StatefulWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final Future<void> Function() onSubmit;
  final bool isLoading;

  const ChangePasswordBottomSheet({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  bool _isCurrentPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_isSubmitting || widget.isLoading) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit();
    } finally {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final loading = widget.isLoading || _isSubmitting;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.67,
        minChildSize: 0.62,
        maxChildSize: 0.96,
        expand: false,
        builder: (context, scrollController) {
          return CustomBackgroundWithChild(
            width: double.infinity,
            backgroundColor: appColors.whiteToblack,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Column(
              children: [
                const SettingsBottomSheetHeader(title: 'تغيير كلمة المرور'),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.045),
                        vertical: SizeConfig.h(0.018),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _PasswordRequirementsMessage(),

                          SizedBox(height: SizeConfig.h(0.025)),

                          AuthFieldLabel(
                            label: 'كلمة المرور الحالية',
                            controller: widget.currentPasswordController,
                            hint: 'أدخل كلمة المرور الحالية الخاصة بك...',
                            compact: true,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isCurrentPasswordObscure,
                            suffixIcon: _isCurrentPasswordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onSuffixTap: () {
                              setState(() {
                                _isCurrentPasswordObscure =
                                    !_isCurrentPasswordObscure;
                              });
                            },
                            validator: _validateCurrentPassword,
                          ),

                          SizedBox(height: SizeConfig.h(0.02)),

                          AuthFieldLabel(
                            label: 'كلمة المرور الجديدة',
                            controller: widget.newPasswordController,
                            hint: 'أدخل كلمة المرور الجديدة...',
                            compact: true,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isNewPasswordObscure,
                            suffixIcon: _isNewPasswordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onSuffixTap: () {
                              setState(() {
                                _isNewPasswordObscure = !_isNewPasswordObscure;
                              });
                            },
                            validator: _validateNewPassword,
                          ),

                          SizedBox(height: SizeConfig.h(0.02)),

                          AuthFieldLabel(
                            label: 'إعادة كلمة المرور الجديدة',
                            controller: widget.confirmPasswordController,
                            hint: 'أعد كتابة كلمة المرور الجديدة...',
                            compact: true,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isConfirmPasswordObscure,
                            suffixIcon: _isConfirmPasswordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            onSuffixTap: () {
                              setState(() {
                                _isConfirmPasswordObscure =
                                    !_isConfirmPasswordObscure;
                              });
                            },
                            validator: _validateConfirmPassword,
                          ),

                          SizedBox(height: SizeConfig.h(0.03)),

                          CustomButtonWidget(
                            width: double.infinity,
                            onTap: loading ? () {} : _submit,
                            backgroundColor: appColors.primaryToPrimaryDark,
                            borderRadius: 7,
                            childHorizontalPad: SizeConfig.w(0.035),
                            childVerticalPad: SizeConfig.h(0.012),
                            child: loading
                                ? SizedBox(
                                    width: SizeConfig.w(0.05),
                                    height: SizeConfig.w(0.05),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : CustomTextWidget(
                                    'حفظ كلمة المرور',
                                    color: Colors.white,
                                    fontFamily: AppFont.elMessiriBold,
                                    fontSize: SizeConfig.text(0.03),
                                  ),
                          ),

                          SizedBox(height: SizeConfig.h(0.02)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _validateCurrentPassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'يرجى إدخال كلمة المرور الحالية';
    }

    return null;
  }

  String? _validateNewPassword(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'يرجى إدخال كلمة المرور الجديدة';
    }

    if (password.length < 6) {
      return 'يجب ألا تقل كلمة المرور عن 6 أحرف';
    }

    if (!_containsLetter(password)) {
      return 'يجب أن تحتوي كلمة المرور على حرف واحد على الأقل';
    }

    if (!_containsNumber(password)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
    }


    if (password == widget.currentPasswordController.text.trim()) {
      return 'يجب أن تختلف كلمة المرور الجديدة عن الحالية';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmation = value?.trim() ?? '';
    final newPassword = widget.newPasswordController.text.trim();

    if (confirmation.isEmpty) {
      return 'يرجى إعادة كتابة كلمة المرور الجديدة';
    }

    if (confirmation != newPassword) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }

  bool _containsLetter(String value) {
    return RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(value);
  }

  bool _containsNumber(String value) {
    return RegExp(r'[0-9]').hasMatch(value);
  }

}

class _PasswordRequirementsMessage extends StatelessWidget {
  const _PasswordRequirementsMessage();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: SizeConfig.w(0.055),
            color: AppPalette.red,
          ),

          SizedBox(width: SizeConfig.w(0.02)),

          Expanded(
            child: CustomTextWidget(
              'يجب ألا تقل كلمة المرور عن 6 أحرف، وأن تتضمن مزيجاً من الأحرف والأرقام والرموز الخاصة.',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.026),
              textAlign: TextAlign.right,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
