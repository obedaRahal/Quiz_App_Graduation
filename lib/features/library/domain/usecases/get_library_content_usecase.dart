import '../entities/library_params.dart';
import '../entities/library_response_entity.dart';
import '../repositories/library_repository.dart';

class GetLibraryContentUseCase {
  final LibraryRepository repository;

  const GetLibraryContentUseCase(this.repository);

  Future<LibraryResponseEntity> call(LibraryParams params) async {
    return repository.getLibraryContent(params);
  }
}