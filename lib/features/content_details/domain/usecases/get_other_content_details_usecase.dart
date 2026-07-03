import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart';

import '../entities/other_content_details_entity.dart';
import '../entities/other_content_details_params.dart';

class GetOtherContentDetailsUseCase {
  final OtherContentDetailsRepository repository;

  const GetOtherContentDetailsUseCase(this.repository);

  Future<OtherContentDetailsEntity> call(
    OtherContentDetailsParams params,
  ) async {
    return repository.getOtherContentDetails(params);
  }
}