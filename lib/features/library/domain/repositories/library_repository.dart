import '../entities/library_params.dart';
import '../entities/library_response_entity.dart';

abstract class LibraryRepository {
  Future<LibraryResponseEntity> getLibraryContent(LibraryParams params);
}