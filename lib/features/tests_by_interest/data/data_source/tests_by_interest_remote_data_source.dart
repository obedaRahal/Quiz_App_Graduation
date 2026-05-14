import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/tests_by_interest/data/models/tests_by_interest_response_model.dart';

abstract class TestsByInterestRemoteDataSource {
  Future<TestsByInterestResponseModel> getTestsByInterest({
    required int interestId,
    required int page,
  });
  Future<TestsByInterestResponseModel> searchTestsByInterest({
  required int interestId,
  required String query,
  required int page,
  int perPage = 10,
});
}

class TestsByInterestRemoteDataSourceImpl
    implements TestsByInterestRemoteDataSource {
  final ApiConsumer apiConsumer;

  const TestsByInterestRemoteDataSourceImpl({
    required this.apiConsumer,
  });

  @override
  Future<TestsByInterestResponseModel> getTestsByInterest({
    required int interestId,
    required int page,
  }) async {
    final response = await apiConsumer.get(
      '${EndPoints.testByInterest}/$interestId',
      queryParameters: {
        'page': page,
      },
    );

    return TestsByInterestResponseModel.fromJson(response);
  }
  @override
Future<TestsByInterestResponseModel> searchTestsByInterest({
  required int interestId,
  required String query,
  required int page,
  int perPage = 10,
}) async {
  final response = await apiConsumer.post(
    EndPoints.searchTestByInterest,
    data: {
      'interest_id': interestId,
      'q': query,
      'page': page,
      'per_page': perPage,
    },
  );

  return TestsByInterestResponseModel.fromJson(response);
}
}