import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_bookmark_repository.dart';

import '../entities/other_content_bookmark_response_entity.dart';

class BookmarkOtherContentUseCase {
  final OtherContentBookmarkRepository repository;

  const BookmarkOtherContentUseCase(this.repository);

  Future<OtherContentBookmarkResponseEntity> call(int contentId) {
    return repository.bookmarkContent(contentId);
  }
}