import 'package:quiz_app_grad/features/laboratory/domain/entities/filter_tests_params.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/filter_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';

class FilterTestsUseCase {
  final LaboratoryRepository repository;

  const FilterTestsUseCase(this.repository);

  Future<FilterTestsResponseEntity> call({
    required FilterTestsParams params,
  }) {
    return repository.filterTests(params: params);
  }
}