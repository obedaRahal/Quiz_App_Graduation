enum Gender { male, female }
class RegisterState {
  final bool isPasswordObscure;
  final Gender? selectedGender;

  const RegisterState({this.isPasswordObscure = true,this.selectedGender,});

  RegisterState copyWith({bool? isPasswordObscure, Gender? selectedGender,}) {
    return RegisterState(
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}