import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/core/services/file_picker_service_impl.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';
import 'package:quiz_app_grad/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:quiz_app_grad/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_request_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_reset_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_verify_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/login_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/verify_email_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:quiz_app_grad/features/onboarding/data/repository_impl/onboarding_repository_impl.dart';
import 'package:quiz_app_grad/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_interests_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_current_university_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_discovery_source_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_education_level_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_graduate_academic_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_school_stage_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_user_interests_use_case.dart';
import 'package:quiz_app_grad/features/settimgs/data/data_source/theme_local_data_source.dart';
import 'package:quiz_app_grad/features/settimgs/data/repository_impl/theme_repository_impl.dart';
import 'package:quiz_app_grad/features/settimgs/domain/repositories/theme_repository.dart';
import 'package:quiz_app_grad/features/settimgs/domain/use_cases/get_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settimgs/domain/use_cases/set_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settimgs/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_cubit.dart';

import '../database/api/api_consumer.dart';
import '../database/api/dio_consumer.dart';
import '../database/api/end_point.dart';
import '../database/cache/token_storage.dart';
import '../utils/auth_session.dart';

final sl = GetIt.instance;

Future<void> initSl() async {
  await _registerCore();
  _registerThemeFeature();
  _registerOnboardingFeature();
  _registerFilePickerFeature();
  _registerAuthFeature();
}

Future<void> _registerCore() async {
  if (!sl.isRegistered<AuthSession>()) {
    sl.registerLazySingleton<AuthSession>(() => AuthSession());
  }

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ),
    );
  }

  if (!sl.isRegistered<ApiConsumer>()) {
    sl.registerLazySingleton<ApiConsumer>(
      () => DioConsumer(
        dio: sl<Dio>(),
        getAccessToken: TokenStorage.getAccessToken,
        clearSession: () async {
          await TokenStorage.clear();
          sl<AuthSession>().markUnauthenticated();
        },
      ),
    );
  }
}

void _registerThemeFeature() {
  if (!sl.isRegistered<ThemeLocalDataSource>()) {
    sl.registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(),
    );
  }

  if (!sl.isRegistered<ThemeRepository>()) {
    sl.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(localDataSource: sl<ThemeLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<GetThemeModeUseCase>()) {
    sl.registerLazySingleton<GetThemeModeUseCase>(
      () => GetThemeModeUseCase(sl<ThemeRepository>()),
    );
  }

  if (!sl.isRegistered<SetThemeModeUseCase>()) {
    sl.registerLazySingleton<SetThemeModeUseCase>(
      () => SetThemeModeUseCase(sl<ThemeRepository>()),
    );
  }

  if (!sl.isRegistered<ThemeCubit>()) {
    sl.registerFactory<ThemeCubit>(
      () => ThemeCubit(
        getThemeModeUseCase: sl<GetThemeModeUseCase>(),
        setThemeModeUseCase: sl<SetThemeModeUseCase>(),
      ),
    );
  }
}

void _registerOnboardingFeature() {
  if (!sl.isRegistered<OnboardingRemoteDataSource>()) {
    sl.registerLazySingleton<OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(
        remoteDataSource: sl<OnboardingRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<SubmitDiscoverySourceUseCase>()) {
    sl.registerLazySingleton<SubmitDiscoverySourceUseCase>(
      () => SubmitDiscoverySourceUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitEducationLevelUseCase>()) {
    sl.registerLazySingleton<SubmitEducationLevelUseCase>(
      () => SubmitEducationLevelUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitSchoolStageUseCase>()) {
    sl.registerLazySingleton<SubmitSchoolStageUseCase>(
      () => SubmitSchoolStageUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitCurrentUniversityProfileUseCase>()) {
    sl.registerLazySingleton<SubmitCurrentUniversityProfileUseCase>(
      () => SubmitCurrentUniversityProfileUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitGraduateAcademicProfileUseCase>()) {
    sl.registerLazySingleton<SubmitGraduateAcademicProfileUseCase>(
      () => SubmitGraduateAcademicProfileUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<GetOnboardingInterestsUseCase>()) {
    sl.registerLazySingleton<GetOnboardingInterestsUseCase>(
      () => GetOnboardingInterestsUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitUserInterestsUseCase>()) {
    sl.registerLazySingleton<SubmitUserInterestsUseCase>(
      () => SubmitUserInterestsUseCase(sl<OnboardingRepository>()),
    );
  }
}

void _registerFilePickerFeature() {
  if (!sl.isRegistered<FilePickerService>()) {
    sl.registerLazySingleton<FilePickerService>(() => FilePickerServiceImpl());
  }
}

void _registerAuthFeature() {
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () =>
          AuthRepositoryImpl(authRemoteDataSource: sl<AuthRemoteDataSource>()),
    );
  }

  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<RegisterCubit>()) {
    sl.registerFactory<RegisterCubit>(
      () => RegisterCubit(sl<RegisterUseCase>()),
    );
  }
  if (!sl.isRegistered<VerifyEmailUseCase>()) {
    sl.registerLazySingleton<VerifyEmailUseCase>(
      () => VerifyEmailUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<VerifyRegisterCubit>()) {
    sl.registerFactory<VerifyRegisterCubit>(
      () => VerifyRegisterCubit(
        verifyEmailUseCase: sl<VerifyEmailUseCase>(),
        resendOtpUseCase: sl<ResendOtpUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<VerifyEmailUseCase>()) {
    sl.registerLazySingleton<VerifyEmailUseCase>(
      () => VerifyEmailUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<LoginCubit>()) {
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: sl<LoginUseCase>(),
      resendOtpUseCase: sl<ResendOtpUseCase>(),
    ),
  );
}
  if (!sl.isRegistered<ResendOtpUseCase>()) {
    sl.registerLazySingleton<ResendOtpUseCase>(
      () => ResendOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<VerifyRegisterCubit>()) {
    sl.registerFactory<VerifyRegisterCubit>(
      () => VerifyRegisterCubit(
        verifyEmailUseCase: sl<VerifyEmailUseCase>(),
        resendOtpUseCase: sl<ResendOtpUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<ForgotPasswordRequestOtpUseCase>()) {
    sl.registerLazySingleton<ForgotPasswordRequestOtpUseCase>(
      () => ForgotPasswordRequestOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<ForgotPasswordVerifyOtpUseCase>()) {
    sl.registerLazySingleton<ForgotPasswordVerifyOtpUseCase>(
      () => ForgotPasswordVerifyOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<ForgetPasswordCubit>()) {
    sl.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(
        forgotPasswordRequestOtpUseCase: sl<ForgotPasswordRequestOtpUseCase>(),
      forgotPasswordVerifyOtpUseCase: sl<ForgotPasswordVerifyOtpUseCase>(),
      forgotPasswordResendOtpUseCase: sl<ForgotPasswordResendOtpUseCase>(),
      forgotPasswordResetUseCase: sl<ForgotPasswordResetUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<ForgotPasswordResendOtpUseCase>()) {
  sl.registerLazySingleton<ForgotPasswordResendOtpUseCase>(
    () => ForgotPasswordResendOtpUseCase(
      sl<AuthRepository>(),
    ),
  );
}
if (!sl.isRegistered<ForgotPasswordResetUseCase>()) {
  sl.registerLazySingleton<ForgotPasswordResetUseCase>(
    () => ForgotPasswordResetUseCase(
      sl<AuthRepository>(),
    ),
  );
}
}
