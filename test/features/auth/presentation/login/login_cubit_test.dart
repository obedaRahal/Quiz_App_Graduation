import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/resend_otp_response_entity.dart';

import 'package:quiz_app_grad/features/auth/domain/use_cases/login_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockResendOtpUseCase extends Mock implements ResendOtpUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockResendOtpUseCase mockResendOtpUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockResendOtpUseCase = MockResendOtpUseCase();
  });

  LoginCubit buildCubit() {
    return LoginCubit(
      loginUseCase: mockLoginUseCase,
      resendOtpUseCase: mockResendOtpUseCase,
    );
  }

  group('LoginCubit', () {
    test('initial state should be correct', () {
      final cubit = buildCubit();

      expect(cubit.state.loginStatus, LoginStatus.initial);
      expect(cubit.state.isPasswordObscure, true);
      expect(cubit.state.errorMessage, null);
      expect(cubit.state.successMessage, null);
      expect(cubit.state.failureType, LoginFailureType.none);

      cubit.close();
    });

    blocTest<LoginCubit, LoginState>(
      'togglePasswordVisibility should change isPasswordObscure from true to false',
      build: () => buildCubit(),
      act: (cubit) => cubit.togglePasswordVisibility(),
      expect: () => [
        isA<LoginState>().having(
          (state) => state.isPasswordObscure,
          'isPasswordObscure',
          false,
        ),
      ],
    );
  });
}