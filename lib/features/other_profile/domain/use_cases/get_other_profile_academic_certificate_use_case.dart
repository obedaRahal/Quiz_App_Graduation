import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_academic_certificate_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_academic_certificate_params.dart';

class GetOtherProfileAcademicCertificateUseCase {
  final OtherProfileRepository repository;

  const GetOtherProfileAcademicCertificateUseCase(this.repository);

  Future<Either<Failure, OtherProfileAcademicCertificateEntity>> call(
    GetOtherProfileAcademicCertificateParams params,
  ) {
    debugPrint(
      "============ GetOtherProfileAcademicCertificateUseCase.call ============",
    );
    debugPrint("→ params: {userId: ${params.userId}}");

    return repository.getOtherProfileAcademicCertificate(
      userId: params.userId,
    );
  }
}