import 'package:quiz_app_grad/features/settings/domain/enums/academic_verification_status.dart';

class AcademicVerificationEntity {
  final bool hasRequest;
  final AcademicVerificationStatus status;

  final String? submittedAt;
  final String? approvedAt;

  final bool showCertificatePublicly;

  final String? rejectionReason;

  final int cancellationCount;
  final int remainingCancellations;

  const AcademicVerificationEntity({
    required this.hasRequest,
    required this.status,
    required this.submittedAt,
    required this.approvedAt,
    required this.showCertificatePublicly,
    required this.rejectionReason,
    required this.cancellationCount,
    required this.remainingCancellations,
  });

  bool get hasNoRequest {
    return status == AcademicVerificationStatus.none;
  }

  bool get isPending {
    return status == AcademicVerificationStatus.pending;
  }

  bool get isApproved {
    return status == AcademicVerificationStatus.approved;
  }

  bool get isRejected {
    return status == AcademicVerificationStatus.rejected;
  }

  bool get canCancelRequest {
    return isPending && remainingCancellations > 0;
  }

  AcademicVerificationEntity copyWith({
    bool? hasRequest,
    AcademicVerificationStatus? status,
    String? submittedAt,
    bool clearSubmittedAt = false,
    String? approvedAt,
    bool clearApprovedAt = false,
    bool? showCertificatePublicly,
    String? rejectionReason,
    bool clearRejectionReason = false,
    int? cancellationCount,
    int? remainingCancellations,
  }) {
    return AcademicVerificationEntity(
      hasRequest: hasRequest ?? this.hasRequest,
      status: status ?? this.status,
      submittedAt: clearSubmittedAt
          ? null
          : submittedAt ?? this.submittedAt,
      approvedAt: clearApprovedAt
          ? null
          : approvedAt ?? this.approvedAt,
      showCertificatePublicly:
          showCertificatePublicly ??
          this.showCertificatePublicly,
      rejectionReason: clearRejectionReason
          ? null
          : rejectionReason ?? this.rejectionReason,
      cancellationCount:
          cancellationCount ?? this.cancellationCount,
      remainingCancellations:
          remainingCancellations ??
          this.remainingCancellations,
    );
  }
}