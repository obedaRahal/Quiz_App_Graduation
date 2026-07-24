import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/settings_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/logout_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_date_time_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_password_params.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();

  Future<Either<Failure, Unit>> enableTaskReminders();

  Future<Either<Failure, Unit>> disableTaskReminders();

  Future<Either<Failure, Unit>> updateThemeMode({required String themeMode});

  Future<Either<Failure, Unit>> updateDateTime({
    required UpdateDateTimeParams params,
  });

  Future<Either<Failure, Unit>> updatePassword({
    required UpdatePasswordParams params,
  });

  Future<Either<Failure, Unit>> logout({required LogoutParams params});
}
