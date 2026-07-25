import 'package:quiz_app_grad/features/settings/domain/entity/academic_verification_entity.dart';

enum AcademicVerificationSubmitStatus { initial, loading, success, failure }

enum AcademicVerificationCancelStatus { initial, loading, success, failure }

enum AcademicVerificationVisibilityStatus { initial, loading, success, failure }

class AcademicVerificationState {
  final bool isLoading;

  final AcademicVerificationEntity? verification;

  final String? certificateImagePath;
  final String? identityImagePath;

  final String? errorTitle;
  final String? errorMessage;

  final AcademicVerificationSubmitStatus submitStatus;
  final String? submitSuccessTitle;
  final String? submitSuccessMessage;
  final String? submitErrorTitle;
  final String? submitErrorMessage;

  final AcademicVerificationCancelStatus cancelStatus;
  final String? cancelSuccessTitle;
  final String? cancelSuccessMessage;
  final String? cancelErrorTitle;
  final String? cancelErrorMessage;

  final AcademicVerificationVisibilityStatus visibilityStatus;
  final String? visibilitySuccessTitle;
  final String? visibilitySuccessMessage;
  final String? visibilityErrorTitle;
  final String? visibilityErrorMessage;

  const AcademicVerificationState({
    this.isLoading = false,
    this.verification,
    this.certificateImagePath,
    this.identityImagePath,
    this.errorTitle,
    this.errorMessage,
    this.submitStatus = AcademicVerificationSubmitStatus.initial,
    this.submitSuccessTitle,
    this.submitSuccessMessage,
    this.submitErrorTitle,
    this.submitErrorMessage,
    this.cancelStatus = AcademicVerificationCancelStatus.initial,
    this.cancelSuccessTitle,
    this.cancelSuccessMessage,
    this.cancelErrorTitle,
    this.cancelErrorMessage,
    this.visibilityStatus = AcademicVerificationVisibilityStatus.initial,
    this.visibilitySuccessTitle,
    this.visibilitySuccessMessage,
    this.visibilityErrorTitle,
    this.visibilityErrorMessage,
  });

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  bool get hasVerification {
    return verification != null;
  }

  bool get hasCertificateImage {
    return certificateImagePath != null &&
        certificateImagePath!.trim().isNotEmpty;
  }

  bool get hasIdentityImage {
    return identityImagePath != null && identityImagePath!.trim().isNotEmpty;
  }

  bool get canSubmitRequest {
    return hasCertificateImage && hasIdentityImage && !isSubmitLoading;
  }

  bool get isSubmitLoading {
    return submitStatus == AcademicVerificationSubmitStatus.loading;
  }

  bool get isSubmitSuccess {
    return submitStatus == AcademicVerificationSubmitStatus.success;
  }

  bool get isSubmitFailure {
    return submitStatus == AcademicVerificationSubmitStatus.failure;
  }

  bool get isCancelLoading {
    return cancelStatus == AcademicVerificationCancelStatus.loading;
  }

  bool get isCancelSuccess {
    return cancelStatus == AcademicVerificationCancelStatus.success;
  }

  bool get isCancelFailure {
    return cancelStatus == AcademicVerificationCancelStatus.failure;
  }

  bool get isVisibilityLoading {
    return visibilityStatus == AcademicVerificationVisibilityStatus.loading;
  }

  bool get isVisibilitySuccess {
    return visibilityStatus == AcademicVerificationVisibilityStatus.success;
  }

  bool get isVisibilityFailure {
    return visibilityStatus == AcademicVerificationVisibilityStatus.failure;
  }

  AcademicVerificationState copyWith({
    bool? isLoading,

    AcademicVerificationEntity? verification,
    bool clearVerification = false,

    String? certificateImagePath,
    bool clearCertificateImagePath = false,

    String? identityImagePath,
    bool clearIdentityImagePath = false,

    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    AcademicVerificationSubmitStatus? submitStatus,
    String? submitSuccessTitle,
    String? submitSuccessMessage,
    String? submitErrorTitle,
    String? submitErrorMessage,
    bool clearSubmitMessage = false,

    AcademicVerificationCancelStatus? cancelStatus,
    String? cancelSuccessTitle,
    String? cancelSuccessMessage,
    String? cancelErrorTitle,
    String? cancelErrorMessage,
    bool clearCancelMessage = false,

    AcademicVerificationVisibilityStatus? visibilityStatus,
    String? visibilitySuccessTitle,
    String? visibilitySuccessMessage,
    String? visibilityErrorTitle,
    String? visibilityErrorMessage,
    bool clearVisibilityMessage = false,
  }) {
    return AcademicVerificationState(
      isLoading: isLoading ?? this.isLoading,

      verification: clearVerification
          ? null
          : verification ?? this.verification,

      certificateImagePath: clearCertificateImagePath
          ? null
          : certificateImagePath ?? this.certificateImagePath,

      identityImagePath: clearIdentityImagePath
          ? null
          : identityImagePath ?? this.identityImagePath,

      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      submitStatus: submitStatus ?? this.submitStatus,

      submitSuccessTitle: clearSubmitMessage
          ? null
          : submitSuccessTitle ?? this.submitSuccessTitle,

      submitSuccessMessage: clearSubmitMessage
          ? null
          : submitSuccessMessage ?? this.submitSuccessMessage,

      submitErrorTitle: clearSubmitMessage
          ? null
          : submitErrorTitle ?? this.submitErrorTitle,

      submitErrorMessage: clearSubmitMessage
          ? null
          : submitErrorMessage ?? this.submitErrorMessage,

      cancelStatus: cancelStatus ?? this.cancelStatus,

      cancelSuccessTitle: clearCancelMessage
          ? null
          : cancelSuccessTitle ?? this.cancelSuccessTitle,

      cancelSuccessMessage: clearCancelMessage
          ? null
          : cancelSuccessMessage ?? this.cancelSuccessMessage,

      cancelErrorTitle: clearCancelMessage
          ? null
          : cancelErrorTitle ?? this.cancelErrorTitle,

      cancelErrorMessage: clearCancelMessage
          ? null
          : cancelErrorMessage ?? this.cancelErrorMessage,

      visibilityStatus: visibilityStatus ?? this.visibilityStatus,

      visibilitySuccessTitle: clearVisibilityMessage
          ? null
          : visibilitySuccessTitle ?? this.visibilitySuccessTitle,

      visibilitySuccessMessage: clearVisibilityMessage
          ? null
          : visibilitySuccessMessage ?? this.visibilitySuccessMessage,

      visibilityErrorTitle: clearVisibilityMessage
          ? null
          : visibilityErrorTitle ?? this.visibilityErrorTitle,

      visibilityErrorMessage: clearVisibilityMessage
          ? null
          : visibilityErrorMessage ?? this.visibilityErrorMessage,
    );
  }
}
