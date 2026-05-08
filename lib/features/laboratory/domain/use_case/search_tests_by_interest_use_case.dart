import 'package:quiz_app_grad/features/laboratory/domain/entities/search_tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';

class SearchTestsByInterestUseCase {
  final LaboratoryRepository repository;

  const SearchTestsByInterestUseCase(this.repository);

  Future<SearchTestsByInterestResponseEntity> call({
    required String query,
    required int page,
    int perPage = 20,
  }) {
    return repository.searchTestsByInterest(
      query: query,
      page: page,
      perPage: perPage,
    );
  }
}