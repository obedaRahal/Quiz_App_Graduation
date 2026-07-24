import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/settings/data/models/get_settings_response_model.dart';
import 'package:quiz_app_grad/features/settings/data/models/settings_operation_response_model.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/logout_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_date_time_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_password_params.dart';

abstract class SettingsRemoteDataSource {
  Future<GetSettingsResponseModel> getSettings();

  Future<SettingsOperationResponseModel> enableTaskReminders();

  Future<SettingsOperationResponseModel> disableTaskReminders();

  Future<SettingsOperationResponseModel> updateThemeMode({
    required String themeMode,
  });

  Future<SettingsOperationResponseModel> updateDateTime({
    required UpdateDateTimeParams params,
  });

  Future<SettingsOperationResponseModel> updatePassword({
    required UpdatePasswordParams params,
  });

  Future<SettingsOperationResponseModel> logout({required LogoutParams params});
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiConsumer apiConsumer;

  const SettingsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<GetSettingsResponseModel> getSettings() async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.getSettings ============',
    );

    debugPrint('→ endpoint: ${EndPoints.getSettings}');
    debugPrint('→ method: GET');

    final response = await apiConsumer.get(EndPoints.getSettings);

    debugPrint('← response: $response');
    debugPrint(
      '=================================================================',
    );

    return GetSettingsResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SettingsOperationResponseModel> enableTaskReminders() async {
    debugPrint(
      "============ SettingsRemoteDataSourceImpl.enableTaskReminders ============",
    );

    final response = await apiConsumer.patch(EndPoints.enableTaskReminders);

    return SettingsOperationResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SettingsOperationResponseModel> disableTaskReminders() async {
    debugPrint(
      "============ SettingsRemoteDataSourceImpl.disableTaskReminders ============",
    );

    final response = await apiConsumer.patch(EndPoints.disableTaskReminders);

    return SettingsOperationResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SettingsOperationResponseModel> updateThemeMode({
    required String themeMode,
  }) async {
    debugPrint(
      "============ SettingsRemoteDataSourceImpl.updateThemeMode ============",
    );

    debugPrint("→ themeMode: $themeMode");

    final response = await apiConsumer.post(
      EndPoints.updateThemeMode,
      data: {'theme_mode': themeMode},
    );

    return SettingsOperationResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SettingsOperationResponseModel> updateDateTime({
    required UpdateDateTimeParams params,
  }) async {
    debugPrint(
      "============ SettingsRemoteDataSourceImpl.updateDateTime ============",
    );

    debugPrint("→ body: ${params.toJson()}");

    final response = await apiConsumer.post(
      EndPoints.updateDateTime,
      data: params.toJson(),
    );

    return SettingsOperationResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SettingsOperationResponseModel> updatePassword({
    required UpdatePasswordParams params,
  }) async {
    debugPrint(
      "============ SettingsRemoteDataSourceImpl.updatePassword ============",
    );

    debugPrint("→ body: ${params.toJson()}");
    debugPrint("→ end point is: ${EndPoints.updatePassword}");

    final response = await apiConsumer.post(
      EndPoints.updatePassword,
      data: params.toJson(),
    );

    return SettingsOperationResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<SettingsOperationResponseModel> logout({
    required LogoutParams params,
  }) async {
    debugPrint("============ SettingsRemoteDataSourceImpl.logout ============");

    debugPrint("→ body: ${params.toJson()}");

    final response = await apiConsumer.post(
      EndPoints.logout,
      data: params.toJson(),
    );

    return SettingsOperationResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }
}
