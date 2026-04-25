// enum Gender { male, female }
// class RegisterState {
//   final bool isPasswordObscure;
//   final Gender? selectedGender;

//   const RegisterState({this.isPasswordObscure = true,this.selectedGender,});

//   RegisterState copyWith({bool? isPasswordObscure, Gender? selectedGender,}) {
//     return RegisterState(
//       isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
//       selectedGender: selectedGender ?? this.selectedGender,
//     );
//   }
// }
enum Gender { male, female }

enum RegisterStatus {
  initial,
  loading,
  success,
  failure,
}

class RegisterState {
  final bool isPasswordObscure;
  final Gender? selectedGender;
  final RegisterStatus registerStatus;
  final String? errorMessage;
    final String? snackBarTitle;
  final String? successMessage;
  final String? otpCode;

  const RegisterState({
    this.isPasswordObscure = true,
    this.selectedGender,
    this.registerStatus = RegisterStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.otpCode,
    this.snackBarTitle,
  });

  RegisterState copyWith({
    bool? isPasswordObscure,
    Gender? selectedGender,
    RegisterStatus? registerStatus,
    String? errorMessage,
    String? successMessage,
    String? otpCode,
    String? snackBarTitle,
  }) {
    return RegisterState(
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      selectedGender: selectedGender ?? this.selectedGender,
      registerStatus: registerStatus ?? this.registerStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
      otpCode: otpCode ?? this.otpCode,
      snackBarTitle: snackBarTitle,
    );
  }
}