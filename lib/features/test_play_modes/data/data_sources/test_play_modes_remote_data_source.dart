import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/models/register_test_attempt_interaction_model.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/models/test_play_content_model.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/get_test_play_content_params.dart';

abstract class TestPlayModesRemoteDataSource {
  Future<TestPlayContentModel> getTestPlayContent(
    GetTestPlayContentParams params,
  );

  Future<RegisterTestAttemptInteractionModel> registerTestAttemptInteraction({
    required int testId,
    required String mode,
  });
}

class TestPlayModesRemoteDataSourceImpl
    implements TestPlayModesRemoteDataSource {
  final ApiConsumer apiConsumer;

  const TestPlayModesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<TestPlayContentModel> getTestPlayContent(
    GetTestPlayContentParams params,
  ) async {
    debugPrint(
      "============ TestPlayModesRemoteDataSourceImpl.getTestPlayContent ============",
    );
    debugPrint("→ params: {testId: ${params.testId}}");

    final response = await apiConsumer.get(
      EndPoints.getTestPlayContent(params.testId),
    );

    debugPrint("✓ test play content response received");
    debugPrint("→ response type: ${response.runtimeType}");
    debugPrint(
      "===============================================================",
    );

    return TestPlayContentModel.fromJson(response);
  }

  @override
  Future<RegisterTestAttemptInteractionModel> registerTestAttemptInteraction({
    required int testId,
    required String mode,
  }) async {
    debugPrint(
      "============ TestPlayModesRemoteDataSourceImpl.registerTestAttemptInteraction ============",
    );

    final endpoint = EndPoints.registerTestAttemptInteraction(testId);

    debugPrint("→ endpoint: $endpoint");
    debugPrint("→ method: POST");
    debugPrint("→ body: {mode: $mode}");

    final response = await apiConsumer.post(endpoint, data: {'mode': mode});

    debugPrint("← response (registerTestAttemptInteraction): $response");
    debugPrint("=================================================");

    return RegisterTestAttemptInteractionModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
