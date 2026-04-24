// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';

// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit() : super(const LoginState());
//  // LoginCubit(super.initialState);
//   void togglePasswordVisibility() {
//     debugPrint(
//       "LoginCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
//     );
//     emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/login_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(const LoginState());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    debugPrint(
      "LoginCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
    );
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  Future<void> submitLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint("========== LoginCubit.submitLogin ==========");
    debugPrint("email => $email");
    debugPrint("password length => ${password.length}");

    if (email.isEmpty) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: 'يرجى إدخال البريد الإلكتروني.',
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: 'يرجى إدخال كلمة المرور.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        loginStatus: LoginStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final result = await loginUseCase(
        email: email,
        password: password,
      );

      debugPrint("LOGIN SUCCESS => token length: ${result.token.length}");
      debugPrint("LOGIN USER => ${result.user.name}");

      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
          successMessage: result.title,
          errorMessage: null,
        ),
      );
    } catch (e, s) {
      debugPrint("LOGIN ERROR => $e");
      debugPrint("LOGIN STACK => $s");

      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}