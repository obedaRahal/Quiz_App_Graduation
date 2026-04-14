import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState>{
   RegisterCubit() : super(const RegisterState());
  void togglePasswordVisibility() {
    debugPrint(
      "RegisterCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
    );
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }
  void selectGender(Gender gender) {
  emit(state.copyWith(selectedGender: gender));
}
}