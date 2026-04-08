import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/dio_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';



final sl = GetIt.instance;

Future<void> initSl() async {
  await _registerCore();
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


