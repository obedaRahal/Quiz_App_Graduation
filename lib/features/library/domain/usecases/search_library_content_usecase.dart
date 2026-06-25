import '../entities/library_search_params.dart';
import '../entities/library_search_response_entity.dart';
import '../repositories/library_repository.dart';

class SearchLibraryContentUseCase {
  final LibraryRepository repository;

  const SearchLibraryContentUseCase(this.repository);

  Future<LibrarySearchResponseEntity> call(
    LibrarySearchParams params,
  ) async {
    return repository.searchLibraryContent(params);
  }
}