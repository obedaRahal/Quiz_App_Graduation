import '../entities/unfollow_publisher_response_entity.dart';
import '../repositories/other_content_details_repository.dart';

class UnfollowPublisherUseCase {
  final OtherContentDetailsRepository repository;

  const UnfollowPublisherUseCase(this.repository);

  Future<UnfollowPublisherResponseEntity> call(int publisherId) {
    return repository.unfollowPublisher(publisherId);
  }
}