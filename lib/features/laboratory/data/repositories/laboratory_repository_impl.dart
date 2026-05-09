import 'package:quiz_app_grad/features/laboratory/data/datasource/laboratory_remote_data_source.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/search_tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';

class LaboratoryRepositoryImpl implements LaboratoryRepository {
  final LaboratoryRemoteDataSource remoteDataSource;

  const LaboratoryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TestsByInterestResponseEntity> getTestsByInterest({
    required int interestId,
    required int page,
  }) async {
    final response = await remoteDataSource.getTestsByInterest(
      interestId: interestId,
      page: page,
    );

    return response.toEntity();
  }
 @override
Future<SearchTestsByInterestResponseEntity> searchTestsByInterest({
  required String query,
  required int page,
  int perPage = 20,
}) async {
  final response = await remoteDataSource.searchTestsByInterest(
    query: query,
    page: page,
    perPage: perPage,
  );

  return response.toEntity();
}
}