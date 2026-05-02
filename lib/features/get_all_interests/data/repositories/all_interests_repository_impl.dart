import 'package:quiz_app_grad/features/get_all_interests/data/data_source/all_interests_remote_data_source.dart';

import '../../domain/entities/all_interests_response_entity.dart';
import '../../domain/repositories/all_interests_repository.dart';

class AllInterestsRepositoryImpl implements AllInterestsRepository {
  final AllInterestsRemoteDataSource remoteDataSource;

  const AllInterestsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<AllInterestsResponseEntity> getAllInterests() async {
    final response = await remoteDataSource.getAllInterests();
    return response.toEntity();
  }
}