import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/follow_publisher_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/content_share_link_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_params.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/similar_content_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/unfollow_publisher_response_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart';

import '../../domain/entities/other_content_details_entity.dart';
import '../../domain/entities/other_content_details_params.dart';
import '../datasources/other_content_details_remote_data_source.dart';

class OtherContentDetailsRepositoryImpl
    implements OtherContentDetailsRepository {
  final OtherContentDetailsRemoteDataSource remoteDataSource;

  const OtherContentDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OtherContentDetailsEntity> getOtherContentDetails(
    OtherContentDetailsParams params,
  ) async {
    debugPrint(
      '================ OtherContentDetailsRepositoryImpl ================',
    );
    debugPrint('contentId: ${params.contentId}');

    return remoteDataSource.getOtherContentDetails(params);
  }

  @override
  Future<String> downloadContent(int contentId) {
    return remoteDataSource.downloadContent(contentId);
  }

  @override
  Future<SimilarContentResponseEntity> getSimilarContent(
    SimilarContentParams params,
  ) {
    return remoteDataSource.getSimilarContent(params);
  }

  @override
  Future<FollowPublisherResponseEntity> followPublisher(int publisherId) {
    return remoteDataSource.followPublisher(publisherId);
  }

  @override
  Future<UnfollowPublisherResponseEntity> unfollowPublisher(int publisherId) {
    return remoteDataSource.unfollowPublisher(publisherId);
  }

  @override
  Future<Either<Failure, ContentShareLinkEntity>> getContentShareLink({
    required int contentId,
  }) async {
    try {
      final model = await remoteDataSource.getContentShareLink(contentId);
      return Right(model.toEntity());
    } on ServerException catch (error) {
      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
          statusCode: error.errorModel.status,
        ),
      );
    } catch (error) {
      debugPrint('getContentShareLink unexpected error: $error');
      return const Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب رابط مشاركة المحتوى',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SharedContentLinkEntity>> resolveSharedContentLink({
    required String slug,
  }) async {
    try {
      final model = await remoteDataSource.resolveSharedContentLink(slug);
      return Right(model.toEntity());
    } on ServerException catch (error) {
      return Left(
        ServerFailure(
          title: error.errorModel.errorTitle,
          message: error.errorModel.errorMessage,
          statusCode: error.errorModel.status,
        ),
      );
    } catch (error) {
      debugPrint('resolveSharedContentLink unexpected error: $error');
      return const Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر فتح رابط المحتوى'),
      );
    }
  }
}
