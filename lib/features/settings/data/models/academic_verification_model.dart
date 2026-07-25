import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/enums/academic_verification_status.dart';

class AcademicVerificationModel
    extends AcademicVerificationEntity {
  const AcademicVerificationModel({
    required super.hasRequest,
    required super.status,
    required super.submittedAt,
    required super.approvedAt,
    required super.showCertificatePublicly,
    required super.rejectionReason,
    required super.cancellationCount,
    required super.remainingCancellations,
  });

  factory AcademicVerificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final hasRequest = _parseBool(
      json['has_request'],
    );

    final rawStatus = json['status']?.toString();

    return AcademicVerificationModel(
      hasRequest: hasRequest,
      status: academicVerificationStatusFromApi(
        hasRequest: hasRequest,
        status: rawStatus,
      ),
      submittedAt: _parseNullableString(
        json['submitted_at'],
      ),
      approvedAt: _parseNullableString(
        json['approved_at'],
      ),
      showCertificatePublicly: _parseBool(
        json['show_certificate_publicly'],
      ),
      rejectionReason: _parseNullableString(
        json['rejection_reason'],
      ),
      cancellationCount: _parseInt(
        json['cancellation_count'],
      ),
      remainingCancellations: _parseInt(
        json['remaining_cancellations'],
      ),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value == 1;
    }

    final normalized = value
        ?.toString()
        .trim()
        .toLowerCase();

    return normalized == 'true' ||
        normalized == '1';
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString().trim() ?? '',
        ) ??
        0;
  }

  static String? _parseNullableString(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    if (result.isEmpty || result == 'null') {
      return null;
    }

    return result;
  }
}