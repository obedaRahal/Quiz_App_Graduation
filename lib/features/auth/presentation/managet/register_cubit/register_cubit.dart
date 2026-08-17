















import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_state.dart';



















class RegisterCubit extends SafeCubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(const RegisterState());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    debugPrint(
      "RegisterCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
    );
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void selectGender(Gender gender) {
    debugPrint("RegisterCubit.selectGender -> $gender");
    emit(state.copyWith(selectedGender: gender));
  }

  String _mapGenderToApiValue(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'انثى';
    }
  }

  String _extractErrorTitle(Object e) {
    try {
      final dynamic exception = e;
      final dynamic errorModel = exception.errorModel;
      final dynamic title = errorModel.errorTitle;

      if (title != null && title.toString().trim().isNotEmpty) {
        return title.toString();
      }
    } catch (_) {}

    return 'خطأ';
  }

  Future<void> submitRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint("========== RegisterCubit.submitRegister ==========");
    debugPrint("registration data prepared");
    debugPrint("selectedGender => ${state.selectedGender}");

    if (name.isEmpty) {
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          snackBarTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال الاسم.',
        ),
      );
      return;
    }

    if (email.isEmpty) {
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          snackBarTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال البريد الإلكتروني.',
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          snackBarTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال كلمة المرور.',
        ),
      );
      return;
    }

    if (state.selectedGender == null) {
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          snackBarTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار الجنس.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        registerStatus: RegisterStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final result = await registerUseCase(
        name: name,
        email: email,
        password: password,
        gender: _mapGenderToApiValue(state.selectedGender!),
      );

      emit(
        state.copyWith(
          registerStatus: RegisterStatus.success,
          snackBarTitle: result.title,
          successMessage: result.title,
          otpCode: result.otpCode,
          errorMessage: null,
        ),
      );
    } catch (e, s) {
      debugPrint("REGISTER ERROR => $e");
      debugPrint("REGISTER STACK => $s");

      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          snackBarTitle: _extractErrorTitle(e),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
