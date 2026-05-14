import 'package:quiz_app_grad/features/tests_by_interest/domain/entities/tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/repositories/tests_by_interest_repository.dart';

class GetTestsByInterestUseCase {
  final TestsByInterestRepository repository;

  const GetTestsByInterestUseCase({
    required this.repository,
  });

  Future<TestsByInterestResponseEntity> call({
    required int interestId,
    required int page,
  }) {
    return repository.getTestsByInterest(
      interestId: interestId,
      page: page,
    );
  }
}