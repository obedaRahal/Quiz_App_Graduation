import '../entities/all_interests_response_entity.dart';
import '../repositories/all_interests_repository.dart';

class GetAllInterestsUseCase {
  final AllInterestsRepository repository;

  const GetAllInterestsUseCase(this.repository);

  Future<AllInterestsResponseEntity> call() {
    return repository.getAllInterests();
  }
}