import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/data/data_source/settings_remote_data_source.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/settings_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/settings_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/logout_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_date_time_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_password_params.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  const SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    debugPrint('============ SettingsRepositoryImpl.getSettings ============');

    try {
      final response = await remoteDataSource.getSettings();

      debugPrint('✓ getSettings success');
      debugPrint(
        '→ taskRemindersEnabled: '
        '${response.data.taskRemindersEnabled}',
      );
      debugPrint('→ weekStartsOn: ${response.data.weekStartsOn}');
      debugPrint('→ timeFormat: ${response.data.timeFormat}');
      debugPrint('→ themeMode: ${response.data.themeMode}');
      debugPrint("→ response: $response");

      debugPrint('===========================================================');

      return Right(response.data);
    } on ServerException catch (e) {
      debugPrint('✗ getSettings ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');

      debugPrint('===========================================================');

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ getSettings CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint('===========================================================');

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ getSettings Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint('===========================================================');

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب إعدادات المستخدم'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> enableTaskReminders() async {
    debugPrint(
      "============ SettingsRepositoryImpl.enableTaskReminders ============",
    );

    try {
      final response = await remoteDataSource.enableTaskReminders();

      debugPrint("√ enableTaskReminders success");
      debugPrint("→ message: ${response.message}");
      debugPrint("→ response: $response");

      return const Right(unit);
    } on ServerException catch (exception) {
      debugPrint("× enableTaskReminders ServerException");

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint("× enableTaskReminders CacheException");

      return Left(
        CacheFailure(
          title: exception.errorMessage,
          message: exception.errorMessage,
        ),
      );
    } catch (exception) {
      debugPrint("× enableTaskReminders unexpected error: $exception");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب إعدادات المستخدم'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> disableTaskReminders() async {
    debugPrint(
      "============ SettingsRepositoryImpl.disableTaskReminders ============",
    );

    try {
      final response = await remoteDataSource.disableTaskReminders();

      debugPrint("√ disableTaskReminders success");
      debugPrint("→ message: ${response.message}");
      debugPrint("→ response: $response");

      return const Right(unit);
    } on ServerException catch (exception) {
      debugPrint("× disableTaskReminders ServerException");

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint("× disableTaskReminders CacheException");

      return Left(
        CacheFailure(
          title: exception.errorMessage,
          message: exception.errorMessage,
        ),
      );
    } catch (exception) {
      debugPrint("× disableTaskReminders unexpected error: $exception");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب إعدادات المستخدم'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateThemeMode({
    required String themeMode,
  }) async {
    debugPrint(
      "============ SettingsRepositoryImpl.updateThemeMode ============",
    );

    try {
      final response = await remoteDataSource.updateThemeMode(
        themeMode: themeMode,
      );

      debugPrint("√ updateThemeMode success");
      debugPrint("→ themeMode: $themeMode");
      debugPrint("→ message: ${response.message}");
      debugPrint("→ response: $response");

      return const Right(unit);
    } on ServerException catch (exception) {
      debugPrint("× updateThemeMode ServerException");

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint("× updateThemeMode CacheException");

      return Left(
        CacheFailure(
          title: exception.errorMessage,
          message: exception.errorMessage,
        ),
      );
    } catch (exception) {
      debugPrint("× updateThemeMode unexpected error: $exception");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب إعدادات المستخدم'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateDateTime({
    required UpdateDateTimeParams params,
  }) async {
    debugPrint(
      "============ SettingsRepositoryImpl.updateDateTime ============",
    );

    try {
      final response = await remoteDataSource.updateDateTime(params: params);

      debugPrint("√ updateDateTime success");
      debugPrint("→ weekStartsOn: ${params.weekStartsOn}");
      debugPrint("→ timeFormat: ${params.timeFormat}");
      debugPrint("→ message: ${response.message}");

      return const Right(unit);
    } on ServerException catch (exception) {
      debugPrint("× updateDateTime ServerException");
      debugPrint("→ title: ${exception.errorModel.errorTitle}");
      debugPrint("→ message: ${exception.errorModel.errorMessage}");

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint("× updateDateTime CacheException");
      debugPrint("→ message: ${exception.errorMessage}");

      return Left(
        CacheFailure(title: 'خطأ محلي', message: exception.errorMessage),
      );
    } catch (exception, stackTrace) {
      debugPrint("× updateDateTime unexpected error: $exception");
      debugPrint("→ stackTrace: $stackTrace");

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تحديث إعدادات التاريخ والوقت',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword({
    required UpdatePasswordParams params,
  }) async {
    debugPrint(
      "============ SettingsRepositoryImpl.updatePassword ============",
    );

    try {
      final response = await remoteDataSource.updatePassword(params: params);

      debugPrint("√ updatePassword success");
      debugPrint("→ message: ${response.message}");

      return const Right(unit);
    } on ServerException catch (exception) {
      debugPrint("× updatePassword ServerException");
      debugPrint("→ title: ${exception.errorModel.errorTitle}");
      debugPrint("→ message: ${exception.errorModel.errorMessage}");

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint("× updatePassword CacheException");
      debugPrint("→ message: ${exception.errorMessage}");

      return Left(
        CacheFailure(title: 'خطأ محلي', message: exception.errorMessage),
      );
    } catch (exception, stackTrace) {
      debugPrint("× updatePassword unexpected error: $exception");
      debugPrint("→ stackTrace: $stackTrace");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تغيير كلمة المرور'),
      );
    }
  }


  @override
  Future<Either<Failure, Unit>> logout({required LogoutParams params}) async {
    debugPrint("============ SettingsRepositoryImpl.logout ============");

    try {
      final response = await remoteDataSource.logout(params: params);

      debugPrint("√ logout success");
      debugPrint("→ message: ${response.message}");

      return const Right(unit);
    } on ServerException catch (exception) {
      debugPrint("× logout ServerException");
      debugPrint("→ title: ${exception.errorModel.errorTitle}");
      debugPrint("→ message: ${exception.errorModel.errorMessage}");

      return Left(
        ServerFailure(
          title: exception.errorModel.errorTitle,
          message: exception.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (exception) {
      debugPrint("× logout CacheException");
      debugPrint("→ message: ${exception.errorMessage}");

      return Left(
        CacheFailure(title: 'خطأ محلي', message: exception.errorMessage),
      );
    } catch (exception, stackTrace) {
      debugPrint("× logout unexpected error: $exception");
      debugPrint("→ stackTrace: $stackTrace");

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر تسجيل الخروج'),
      );
    }
  }
}
