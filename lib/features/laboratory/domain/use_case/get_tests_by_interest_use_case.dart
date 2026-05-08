import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';


class GetTestsByInterestUseCase {
  final LaboratoryRepository repository;

  const GetTestsByInterestUseCase(this.repository);

  Future<TestsByInterestResponseEntity> call({
    required int interestId,
    required int page,
  }) {
    return repository.getTestsByInterest(
      interestId: interestId,
      page: page,
    );
  }
}