import 'package:quiz_app_grad/features/laboratory/domain/entities/filter_tests_params.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/filter_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/search_tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';

abstract class LaboratoryRepository {
  Future<TestsByInterestResponseEntity> getTestsByInterest({
    required int interestId,
    required int page,
  });
Future<SearchTestsByInterestResponseEntity> searchTestsByInterest({
  required String query,
  required int page,
  int perPage = 20,
});
Future<LabRecommendedTestsResponseEntity> getLabRecommendedTests({
  required String tab,
  required int page,
});
Future<FilterTestsResponseEntity> filterTests({
  required FilterTestsParams params,
});
}