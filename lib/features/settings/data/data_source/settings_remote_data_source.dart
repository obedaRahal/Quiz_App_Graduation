import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/settings/data/models/academic_verification_model.dart';
import 'package:quiz_app_grad/features/settings/data/models/get_settings_response_model.dart';
import 'package:quiz_app_grad/features/settings/data/models/purchased_tests_model.dart';
import 'package:quiz_app_grad/features/settings/data/models/settings_operation_response_model.dart';
import 'package:quiz_app_grad/features/settings/data/models/sold_tests_model.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_sold_tests_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_purchased_tests_params.dart';
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

  Future<SoldTestsModel> fetchSoldTests({required FetchSoldTestsParams params});

  Future<PurchasedTestsModel> fetchPurchasedTests({
    required FetchPurchasedTestsParams params,
  });

  Future<AcademicVerificationModel> fetchAcademicVerificationStatus();

  Future<void> createAcademicVerificationRequest({
    required String certificateImagePath,
    required String identityImagePath,
  });

  Future<void> cancelAcademicVerificationRequest();

  Future<void> updateAcademicVerificationVisibility({
    required bool showCertificatePublicly,
  });
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

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint('← response: $response');
    debugPrint(
      '=================================================================',
    );

    return GetSettingsResponseModel.fromJson(responseMap);
  }

  @override
  Future<SettingsOperationResponseModel> enableTaskReminders() async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.enableTaskReminders ============',
    );

    debugPrint('→ endpoint: ${EndPoints.enableTaskReminders}');
    debugPrint('→ method: PATCH');

    final response = await apiConsumer.patch(EndPoints.enableTaskReminders);

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint(
      '=================================================================',
    );

    return SettingsOperationResponseModel.fromJson(responseMap);
  }

  @override
  Future<SettingsOperationResponseModel> disableTaskReminders() async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.disableTaskReminders ============',
    );

    debugPrint('→ endpoint: ${EndPoints.disableTaskReminders}');
    debugPrint('→ method: PATCH');

    final response = await apiConsumer.patch(EndPoints.disableTaskReminders);

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint(
      '=================================================================',
    );

    return SettingsOperationResponseModel.fromJson(responseMap);
  }

  @override
  Future<SettingsOperationResponseModel> updateThemeMode({
    required String themeMode,
  }) async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.updateThemeMode ============',
    );

    debugPrint('→ endpoint: ${EndPoints.updateThemeMode}');
    debugPrint('→ method: POST');
    debugPrint('→ themeMode: $themeMode');

    final response = await apiConsumer.post(
      EndPoints.updateThemeMode,
      data: {'theme_mode': themeMode},
    );

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint(
      '=================================================================',
    );

    return SettingsOperationResponseModel.fromJson(responseMap);
  }

  @override
  Future<SettingsOperationResponseModel> updateDateTime({
    required UpdateDateTimeParams params,
  }) async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.updateDateTime ============',
    );

    debugPrint('→ endpoint: ${EndPoints.updateDateTime}');
    debugPrint('→ method: POST');
    debugPrint('→ body: ${params.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.updateDateTime,
      data: params.toJson(),
    );

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint(
      '=================================================================',
    );

    return SettingsOperationResponseModel.fromJson(responseMap);
  }

  @override
  Future<SettingsOperationResponseModel> updatePassword({
    required UpdatePasswordParams params,
  }) async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.updatePassword ============',
    );

    debugPrint('→ endpoint: ${EndPoints.updatePassword}');
    debugPrint('→ method: POST');
    debugPrint('→ body: ${params.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.updatePassword,
      data: params.toJson(),
    );

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint(
      '=================================================================',
    );

    return SettingsOperationResponseModel.fromJson(responseMap);
  }

  @override
  Future<SettingsOperationResponseModel> logout({
    required LogoutParams params,
  }) async {
    debugPrint('============ SettingsRemoteDataSourceImpl.logout ============');

    debugPrint('→ endpoint: ${EndPoints.logout}');
    debugPrint('→ method: POST');
    debugPrint('→ body: ${params.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.logout,
      data: params.toJson(),
    );

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← response: $responseMap');
    debugPrint(
      '=================================================================',
    );

    return SettingsOperationResponseModel.fromJson(responseMap);
  }

  @override
  Future<SoldTestsModel> fetchSoldTests({
    required FetchSoldTestsParams params,
  }) async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.fetchSoldTests ============',
    );

    debugPrint('→ endpoint: ${EndPoints.soldTests}');
    debugPrint('→ method: GET');
    debugPrint('→ tab: ${params.tab}');
    debugPrint('→ queryParameters: ${params.toQueryParameters()}');

    final response = await apiConsumer.get(
      EndPoints.soldTests,
      queryParameters: params.toQueryParameters(),
    );

    final responseMap = (response as Map).cast<String, dynamic>();

    debugPrint('← success: ${responseMap['success']}');
    debugPrint('← title: ${responseMap['title']}');
    debugPrint('← statusCode: ${responseMap['status_code']}');

    final model = SoldTestsModel.fromJson(responseMap);

    debugPrint('√ totalSalesCount: ${model.stats.totalSalesCount}');
    debugPrint(
      '√ totalSellerNetAmountSyp: '
      '${model.stats.totalSellerNetAmountSyp}',
    );
    debugPrint('√ salesCount: ${model.sales.length}');
    debugPrint(
      '=================================================================',
    );

    return model;
  }

  @override
  Future<PurchasedTestsModel> fetchPurchasedTests({
    required FetchPurchasedTestsParams params,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.purchasedTests,
      queryParameters: params.toQueryParameters(),
    );

    return PurchasedTestsModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<AcademicVerificationModel> fetchAcademicVerificationStatus() async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.fetchAcademicVerificationStatus ============',
    );

    debugPrint('→ endpoint: ${EndPoints.academicVerificationStatus}');
    debugPrint('→ method: GET');

    final response = await apiConsumer.get(
      EndPoints.academicVerificationStatus,
    );

    debugPrint('← response: $response');

    final responseMap = (response as Map).cast<String, dynamic>();

    final dataMap = (responseMap['data'] as Map).cast<String, dynamic>();

    final model = AcademicVerificationModel.fromJson(dataMap);

    debugPrint('✓ academic verification status fetched');
    debugPrint('→ hasRequest: ${model.hasRequest}');
    debugPrint('→ status: ${model.status}');
    debugPrint('→ submittedAt: ${model.submittedAt}');
    debugPrint('→ approvedAt: ${model.approvedAt}');
    debugPrint(
      '→ showCertificatePublicly: '
      '${model.showCertificatePublicly}',
    );
    debugPrint(
      '→ remainingCancellations: '
      '${model.remainingCancellations}',
    );
    debugPrint(
      '===============================================================================================',
    );

    return model;
  }

  @override
  Future<void> createAcademicVerificationRequest({
    required String certificateImagePath,
    required String identityImagePath,
  }) async {
    debugPrint(
      "============ SettingsRemoteDataSourceImpl.createAcademicVerificationRequest ============",
    );

    debugPrint(
      "→ endpoint: ${EndPoints.createAcademicVerificationRequest} "
      "| data: {"
      "certificate_image: $certificateImagePath, "
      "identity_image: $identityImagePath"
      "}",
    );

    final Map<String, dynamic> formMap = {
      'certificate_image': await MultipartFile.fromFile(
        certificateImagePath,
        filename: _extractFileName(certificateImagePath),
      ),
      'identity_image': await MultipartFile.fromFile(
        identityImagePath,
        filename: _extractFileName(identityImagePath),
      ),
    };

    final response = await apiConsumer.post(
      EndPoints.createAcademicVerificationRequest,
      data: FormData.fromMap(formMap),
    );

    debugPrint("← response (createAcademicVerificationRequest): $response");
    debugPrint(
      "================================================================================",
    );
  }

  String _extractFileName(String path) {
    final normalizedPath = path.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  @override
  Future<void> cancelAcademicVerificationRequest() async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.cancelAcademicVerificationRequest ============',
    );
    debugPrint('→ endpoint: ${EndPoints.cancelAcademicVerificationRequest}');
    debugPrint('→ method: DELETE');

    final response = await apiConsumer.delete(
      EndPoints.cancelAcademicVerificationRequest,
    );

    debugPrint('← response (cancelAcademicVerificationRequest): $response');
    debugPrint(
      '=========================================================================================',
    );
  }

  @override
  Future<void> updateAcademicVerificationVisibility({
    required bool showCertificatePublicly,
  }) async {
    debugPrint(
      '============ SettingsRemoteDataSourceImpl.updateAcademicVerificationVisibility ============',
    );
    debugPrint('→ showCertificatePublicly: $showCertificatePublicly');
    debugPrint('→ api value: ${showCertificatePublicly ? 1 : 0}');

    final response = await apiConsumer.post(
      EndPoints.updateAcademicVerificationVisibility,
      data: {'show_certificate_publicly': showCertificatePublicly ? 1 : 0},
    );

    debugPrint('← response (updateAcademicVerificationVisibility): $response');
    debugPrint(
      '=============================================================================================',
    );
  }
}
