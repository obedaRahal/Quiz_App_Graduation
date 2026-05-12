import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/tests_by_interest/data/models/tests_by_interest_response_model.dart';

abstract class TestsByInterestRemoteDataSource {
  Future<TestsByInterestResponseModel> getTestsByInterest({
    required int interestId,
    required int page,
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
}