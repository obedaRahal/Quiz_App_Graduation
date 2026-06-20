import 'package:quiz_app_grad/features/library/domain/entities/library_search_params.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_search_response_entity.dart';

import '../entities/library_params.dart';
import '../entities/library_response_entity.dart';

abstract class LibraryRepository {
  Future<LibraryResponseEntity> getLibraryContent(LibraryParams params);
  Future<LibrarySearchResponseEntity> searchLibraryContent(
    LibrarySearchParams params,
  );
}
