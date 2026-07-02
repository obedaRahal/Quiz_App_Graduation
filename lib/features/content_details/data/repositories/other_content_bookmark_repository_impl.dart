import 'package:quiz_app_grad/features/content_details/data/datasources/other_content_bookmark_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_bookmark_repository.dart';

import '../../domain/entities/other_content_bookmark_response_entity.dart';

class OtherContentBookmarkRepositoryImpl
    implements OtherContentBookmarkRepository {
  final OtherContentBookmarkRemoteDataSource remoteDataSource;

  const OtherContentBookmarkRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<OtherContentBookmarkResponseEntity> bookmarkContent(int contentId) {
    return remoteDataSource.bookmarkContent(contentId);
  }

  @override
  Future<OtherContentBookmarkResponseEntity> unbookmarkContent(int contentId) {
    return remoteDataSource.unbookmarkContent(contentId);
  }
}