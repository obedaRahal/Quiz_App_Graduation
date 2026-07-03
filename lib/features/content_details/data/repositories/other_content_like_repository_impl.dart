import 'package:quiz_app_grad/features/content_details/data/datasources/other_content_like_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_like_repository.dart';

import '../../domain/entities/other_content_like_response_entity.dart';


class OtherContentLikeRepositoryImpl
    implements OtherContentLikeRepository {

  final OtherContentLikeRemoteDataSource remoteDataSource;

  OtherContentLikeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<OtherContentLikeResponseEntity> likeContent(
    int contentId,
  ){

    return remoteDataSource.likeContent(contentId);

  }

  @override
  Future<OtherContentLikeResponseEntity> unlikeContent(
    int contentId,
  ){

    return remoteDataSource.unlikeContent(contentId);

  }

}