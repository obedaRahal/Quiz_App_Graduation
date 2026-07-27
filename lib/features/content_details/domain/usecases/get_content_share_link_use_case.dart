import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/content_details/domain/entities/content_share_link_entity.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart';

class GetContentShareLinkUseCase {
  final OtherContentDetailsRepository repository;

  const GetContentShareLinkUseCase(this.repository);

  Future<Either<Failure, ContentShareLinkEntity>> call(int contentId) {
    return repository.getContentShareLink(contentId: contentId);
  }
}
