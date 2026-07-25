import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/enums/academic_verification_status.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_approved_body.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_no_request_body.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_pending_body.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_rejected_body.dart';

class AcademicVerificationContent
    extends StatelessWidget {
  final AcademicVerificationEntity verification;

  const AcademicVerificationContent({
    super.key,
    required this.verification,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '============ AcademicVerificationContent.build ============',
    );
    debugPrint('→ hasRequest: ${verification.hasRequest}');
    debugPrint('→ status: ${verification.status}');
    debugPrint(
      '→ submittedAt: ${verification.submittedAt}',
    );
    debugPrint(
      '→ approvedAt: ${verification.approvedAt}',
    );
    debugPrint(
      '→ rejectionReason: '
      '${verification.rejectionReason}',
    );
    debugPrint(
      '→ remainingCancellations: '
      '${verification.remainingCancellations}',
    );
    debugPrint(
      '===========================================================',
    );

    switch (verification.status) {
      case AcademicVerificationStatus.none:
        return AcademicVerificationNoRequestBody(
          verification: verification,
        );

      case AcademicVerificationStatus.pending:
        return AcademicVerificationPendingBody(
          verification: verification,
        );

      case AcademicVerificationStatus.approved:
        return AcademicVerificationApprovedBody(
          verification: verification,
        );

      case AcademicVerificationStatus.rejected:
        return AcademicVerificationRejectedBody(
          verification: verification,
        );
    }
  }
}