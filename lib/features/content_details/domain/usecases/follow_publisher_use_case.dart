import '../entities/follow_publisher_response_entity.dart';
import '../repositories/other_content_details_repository.dart';

class FollowPublisherUseCase {
  final OtherContentDetailsRepository repository;

  const FollowPublisherUseCase(this.repository);

  Future<FollowPublisherResponseEntity> call(int publisherId) {
    return repository.followPublisher(publisherId);
  }
}