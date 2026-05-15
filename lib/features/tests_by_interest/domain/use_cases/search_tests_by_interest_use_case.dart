import 'package:quiz_app_grad/features/tests_by_interest/domain/entities/tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/repositories/tests_by_interest_repository.dart';

class SearchTestsByInterestUseCase {
  final TestsByInterestRepository repository;

  const SearchTestsByInterestUseCase({
    required this.repository,
  });

  Future<TestsByInterestResponseEntity> call({
    required int interestId,
    required String query,
    required int page,
    int perPage = 10,
  }) {
    return repository.searchTestsByInterest(
      interestId: interestId,
      query: query,
      page: page,
      perPage: perPage,
    );
  }
}