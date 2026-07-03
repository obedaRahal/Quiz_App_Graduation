import 'package:quiz_app_grad/features/content_details/domain/entities/other_content_bookmark_response_entity.dart';


abstract class OtherContentBookmarkRepository {
  Future<OtherContentBookmarkResponseEntity> bookmarkContent(int contentId);

  Future<OtherContentBookmarkResponseEntity> unbookmarkContent(int contentId);
}