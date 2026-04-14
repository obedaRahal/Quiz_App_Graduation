import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());
 // LoginCubit(super.initialState);
  void togglePasswordVisibility() {
    debugPrint(
      "LoginCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
    );
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }
}
