// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_state.dart';

// class RegisterCubit extends Cubit<RegisterState>{
//    RegisterCubit() : super(const RegisterState());
//   void togglePasswordVisibility() {
//     debugPrint(
//       "RegisterCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
//     );
//     emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
//   }
//   void selectGender(Gender gender) {
//   emit(state.copyWith(selectedGender: gender));
// }
// } 
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_state.dart';

// class RegisterCubit extends Cubit<RegisterState> {
//   final RegisterUseCase registerUseCase;

//   RegisterCubit(this.registerUseCase) : super(const RegisterState());

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void togglePasswordVisibility() {
//     debugPrint(
//       "RegisterCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
//     );
//     emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
//   }

//   void selectGender(Gender gender) {
//     emit(state.copyWith(selectedGender: gender));
//   }

//   String _mapGenderToApiValue(Gender gender) {
//     switch (gender) {
//       case Gender.male:
//         return 'ذكر';
//       case Gender.female:
//         return 'انثى';
//     }
//   }

//   Future<void> submitRegister() async {
//     final name = nameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (name.isEmpty) {
//       emit(
//         state.copyWith(
//           registerStatus: RegisterStatus.failure,
//           errorMessage: 'يرجى إدخال الاسم.',
//         ),
//       );
//       return;
//     }

//     if (email.isEmpty) {
//       emit(
//         state.copyWith(
//           registerStatus: RegisterStatus.failure,
//           errorMessage: 'يرجى إدخال البريد الإلكتروني.',
//         ),
//       );
//       return;
//     }

//     if (password.isEmpty) {
//       emit(
//         state.copyWith(
//           registerStatus: RegisterStatus.failure,
//           errorMessage: 'يرجى إدخال كلمة المرور.',
//         ),
//       );
//       return;
//     }

//     if (state.selectedGender == null) {
//       emit(
//         state.copyWith(
//           registerStatus: RegisterStatus.failure,
//           errorMessage: 'يرجى اختيار الجنس.',
//         ),
//       );
//       return;
//     }

//     emit(
//       state.copyWith(
//         registerStatus: RegisterStatus.loading,
//         errorMessage: null,
//         successMessage: null,
//       ),
//     );

//     try {
//       final result = await registerUseCase(
//         name: name,
//         email: email,
//         password: password,
//         gender: _mapGenderToApiValue(state.selectedGender!),
//       );

//       emit(
//         state.copyWith(
//           registerStatus: RegisterStatus.success,
//           successMessage: 'تم إنشاء الحساب بنجاح.',
//           otpCode: result.otpCode,
//           errorMessage: null,
//         ),
//       );
//     } catch (e) {
//       emit(
//         state.copyWith(
//           registerStatus: RegisterStatus.failure,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }

//   @override
//   Future<void> close() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     return super.close();
//   }
// } 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
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

  Future<void> submitRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint("========== RegisterCubit.submitRegister ==========");
    debugPrint("name => $name");
    debugPrint("email => $email");
    debugPrint("password length => ${password.length}");
    debugPrint("selectedGender => ${state.selectedGender}");

    if (name.isEmpty) {
      debugPrint("Register validation failed => name is empty");
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          errorMessage: 'يرجى إدخال الاسم.',
        ),
      );
      return;
    }

    if (email.isEmpty) {
      debugPrint("Register validation failed => email is empty");
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          errorMessage: 'يرجى إدخال البريد الإلكتروني.',
        ),
      );
      return;
    }

    if (password.isEmpty) {
      debugPrint("Register validation failed => password is empty");
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          errorMessage: 'يرجى إدخال كلمة المرور.',
        ),
      );
      return;
    }

    if (state.selectedGender == null) {
      debugPrint("Register validation failed => gender is null");
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
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
      debugPrint("Register request started...");

      final result = await registerUseCase(
        name: name,
        email: email,
        password: password,
        gender: _mapGenderToApiValue(state.selectedGender!),
      );

      debugPrint("Register request success");
      debugPrint("otpCode => ${result.otpCode}");

      emit(
        state.copyWith(
          registerStatus: RegisterStatus.success,
          successMessage: 'تم إنشاء الحساب بنجاح.',
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