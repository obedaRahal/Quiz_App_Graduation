import '../entities/all_interests_response_entity.dart';

abstract class AllInterestsRepository {
  Future<AllInterestsResponseEntity> getAllInterests();
}