import 'package:quiz_app_grad/features/tests_by_interest/domain/entities/tests_by_interest_response_entity.dart';

abstract class TestsByInterestRepository {
  Future<TestsByInterestResponseEntity> getTestsByInterest({
    required int interestId,
    required int page,
  });
}