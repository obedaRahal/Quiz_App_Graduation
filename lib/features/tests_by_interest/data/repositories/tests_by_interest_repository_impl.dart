import 'package:quiz_app_grad/features/tests_by_interest/data/data_source/tests_by_interest_remote_data_source.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/entities/tests_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/repositories/tests_by_interest_repository.dart';

class TestsByInterestRepositoryImpl implements TestsByInterestRepository {
  final TestsByInterestRemoteDataSource remoteDataSource;

  const TestsByInterestRepositoryImpl({required this.remoteDataSource});

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
  Future<TestsByInterestResponseEntity> searchTestsByInterest({
    required int interestId,
    required String query,
    required int page,
    int perPage = 10,
  }) async {
    final response = await remoteDataSource.searchTestsByInterest(
      interestId: interestId,
      query: query,
      page: page,
      perPage: perPage,
    );

    return response.toEntity();
  }
}
