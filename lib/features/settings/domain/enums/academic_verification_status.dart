enum AcademicVerificationStatus { none, pending, approved, rejected }

extension AcademicVerificationStatusExtension on AcademicVerificationStatus {
  String get label {
    switch (this) {
      case AcademicVerificationStatus.none:
        return 'لا يوجد طلب';

      case AcademicVerificationStatus.pending:
        return 'معلقة';

      case AcademicVerificationStatus.approved:
        return 'تم الموافقة عليها';

      case AcademicVerificationStatus.rejected:
        return 'تم رفضها';
    }
  }
}

AcademicVerificationStatus academicVerificationStatusFromApi({
  required bool hasRequest,
  required String? status,
}) {
  if (!hasRequest) {
    return AcademicVerificationStatus.none;
  }

  switch (status?.trim()) {
    case 'معلقة':
      return AcademicVerificationStatus.pending;

    case 'تم الموافقة عليها':
      return AcademicVerificationStatus.approved;

    case 'تم رفضها':
      return AcademicVerificationStatus.rejected;

    default:
      return AcademicVerificationStatus.none;
  }
}
