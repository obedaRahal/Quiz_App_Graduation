import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/core/services/file_picker_service_impl.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/settimgs/data/data_source/theme_local_data_source.dart';
import 'package:quiz_app_grad/features/settimgs/data/repository_impl/theme_repository_impl.dart';
import 'package:quiz_app_grad/features/settimgs/domain/repositories/theme_repository.dart';
import 'package:quiz_app_grad/features/settimgs/domain/use_cases/get_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settimgs/domain/use_cases/set_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settimgs/presentation/manager/theme_cubit/theme_cubit.dart';

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
  if (!sl.isRegistered<OnboardingCubit>()) {
    sl.registerFactory<OnboardingCubit>(() => OnboardingCubit());
  }
}

void _registerFilePickerFeature() {
  if (!sl.isRegistered<FilePickerService>()) {
    sl.registerLazySingleton<FilePickerService>(() => FilePickerServiceImpl());
  }
}
