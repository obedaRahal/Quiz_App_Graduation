import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/laboratory/data/models/lab_recommended_tests_response_model.dart';
import 'package:quiz_app_grad/features/laboratory/data/models/search_tests_by_interest_response_model.dart';
import 'package:quiz_app_grad/features/laboratory/data/models/tests_by_interest_response_model.dart';

abstract class LaboratoryRemoteDataSource {
  Future<TestsByInterestResponseModel> getTestsByInterest({
    required int interestId,
    required int page,
  });
  Future<SearchTestsByInterestResponseModel> searchTestsByInterest({
    required String query,
    required int page,
    int perPage = 20,
  });
  Future<LabRecommendedTestsResponseModel> getLabRecommendedTests({
    required String tab,
    required int page,
  });
}

class LaboratoryRemoteDataSourceImpl implements LaboratoryRemoteDataSource {
  final ApiConsumer api;

  const LaboratoryRemoteDataSourceImpl({required this.api});

  @override
  Future<TestsByInterestResponseModel> getTestsByInterest({
    required int interestId,
    required int page,
  }) async {
    final response = await api.get(
      EndPoints.testsByInterest(interestId),
      queryParameters: {'page': page},
    );

    return TestsByInterestResponseModel.fromJson(response);
  }

  @override
  Future<SearchTestsByInterestResponseModel> searchTestsByInterest({
    required String query,
    required int page,
    int perPage = 20,
  }) async {
    final response = await api.post(
      EndPoints.searchLabTests,
      data: {'q': query, 'page': page, 'per_page': perPage},
    );

    return SearchTestsByInterestResponseModel.fromJson(response);
  }

  @override
  Future<LabRecommendedTestsResponseModel> getLabRecommendedTests({
    required String tab,
    required int page,
  }) async {
    final response = await api.get(
      EndPoints.labRecommendedTests,
      queryParameters: {'tab': tab, 'page': page},
    );

    return LabRecommendedTestsResponseModel.fromJson(response);
  }
}
