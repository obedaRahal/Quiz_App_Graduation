import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/cancel_academic_verification_request_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/create_academic_verification_request_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/fetch_academic_verification_status_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/create_academic_verification_request_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_academic_verification_visibility_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_academic_verification_visibility_use_case.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/academic_verification/academic_verification_state.dart';

class AcademicVerificationCubit extends SafeCubit<AcademicVerificationState> {
  final FetchAcademicVerificationStatusUseCase
  fetchAcademicVerificationStatusUseCase;

  final CreateAcademicVerificationRequestUseCase
  createAcademicVerificationRequestUseCase;

  final CancelAcademicVerificationRequestUseCase
  cancelAcademicVerificationRequestUseCase;

  final UpdateAcademicVerificationVisibilityUseCase
  updateAcademicVerificationVisibilityUseCase;

  AcademicVerificationCubit({
    required this.fetchAcademicVerificationStatusUseCase,
    required this.createAcademicVerificationRequestUseCase,
    required this.cancelAcademicVerificationRequestUseCase,
    required this.updateAcademicVerificationVisibilityUseCase,
  }) : super(const AcademicVerificationState()) {
    debugPrint('============ AcademicVerificationCubit INIT ============');
  }

  Future<void> fetchInitial() async {
    debugPrint(
      '============ AcademicVerificationCubit.fetchInitial ============',
    );

    if (state.isLoading) {
      debugPrint('→ fetch already in progress');
      debugPrint(
        '===============================================================',
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await fetchAcademicVerificationStatusUseCase();

    result.fold(
      (failure) {
        debugPrint('✗ fetchAcademicVerificationStatus failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (verification) {
        debugPrint('✓ fetchAcademicVerificationStatus success');
        debugPrint('→ hasRequest: ${verification.hasRequest}');
        debugPrint('→ status: ${verification.status}');
        debugPrint('→ submittedAt: ${verification.submittedAt}');
        debugPrint('→ approvedAt: ${verification.approvedAt}');
        debugPrint(
          '→ remainingCancellations: '
          '${verification.remainingCancellations}',
        );

        emit(
          state.copyWith(
            isLoading: false,
            verification: verification,
            clearError: true,
          ),
        );
      },
    );

    debugPrint(
      '===============================================================',
    );
  }

  Future<bool> refresh() async {
    debugPrint('============ AcademicVerificationCubit.refresh ============');

    final result = await fetchAcademicVerificationStatusUseCase();

    return result.fold(
      (failure) {
        debugPrint('✗ refreshAcademicVerification failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');
        debugPrint(
          '===========================================================',
        );

        return false;
      },
      (verification) {
        debugPrint('✓ refreshAcademicVerification success');
        debugPrint('→ hasRequest: ${verification.hasRequest}');
        debugPrint('→ status: ${verification.status}');

        emit(state.copyWith(verification: verification, clearError: true));

        debugPrint(
          '===========================================================',
        );

        return true;
      },
    );
  }

  void certificateImageChanged(String value) {
    debugPrint(
      '============ AcademicVerificationCubit.certificateImageChanged ============',
    );
    debugPrint('→ path: $value');

    emit(
      state.copyWith(
        certificateImagePath: value,
        clearError: true,
        clearSubmitMessage: true,
      ),
    );

    debugPrint('✓ certificate image updated');
    debugPrint(
      '==========================================================================',
    );
  }

  void identityImageChanged(String value) {
    debugPrint(
      '============ AcademicVerificationCubit.identityImageChanged ============',
    );
    debugPrint('→ path: $value');

    emit(
      state.copyWith(
        identityImagePath: value,
        clearError: true,
        clearSubmitMessage: true,
      ),
    );

    debugPrint('✓ identity image updated');
    debugPrint(
      '=======================================================================',
    );
  }

  void clearCertificateImage() {
    debugPrint(
      '============ AcademicVerificationCubit.clearCertificateImage ============',
    );

    emit(
      state.copyWith(clearCertificateImagePath: true, clearSubmitMessage: true),
    );

    debugPrint('✓ certificate image cleared');
    debugPrint(
      '========================================================================',
    );
  }

  void clearIdentityImage() {
    debugPrint(
      '============ AcademicVerificationCubit.clearIdentityImage ============',
    );

    emit(
      state.copyWith(clearIdentityImagePath: true, clearSubmitMessage: true),
    );

    debugPrint('✓ identity image cleared');
    debugPrint(
      '=====================================================================',
    );
  }

  Future<bool> submitRequest() async {
    debugPrint(
      '============ AcademicVerificationCubit.submitRequest ============',
    );

    if (state.isSubmitLoading) {
      debugPrint('→ submit already in progress');
      debugPrint(
        '================================================================',
      );
      return false;
    }

    final certificateImagePath = state.certificateImagePath?.trim();
    final identityImagePath = state.identityImagePath?.trim();

    debugPrint('→ certificateImagePath: $certificateImagePath');
    debugPrint('→ identityImagePath: $identityImagePath');

    if (certificateImagePath == null ||
        certificateImagePath.isEmpty ||
        identityImagePath == null ||
        identityImagePath.isEmpty) {
      debugPrint('✗ required images are missing');

      emit(
        state.copyWith(
          submitStatus: AcademicVerificationSubmitStatus.failure,
          submitErrorTitle: 'تنبيه',
          submitErrorMessage: 'يرجى اختيار صورة الشهادة وصورة الهوية أولًا',
        ),
      );

      debugPrint(
        '================================================================',
      );

      return false;
    }

    emit(
      state.copyWith(
        submitStatus: AcademicVerificationSubmitStatus.loading,
        clearSubmitMessage: true,
      ),
    );

    final result = await createAcademicVerificationRequestUseCase(
      CreateAcademicVerificationRequestParams(
        certificateImagePath: certificateImagePath,
        identityImagePath: identityImagePath,
      ),
    );

    return await result.fold(
      (failure) async {
        debugPrint('✗ createAcademicVerificationRequest failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            submitStatus: AcademicVerificationSubmitStatus.failure,
            submitErrorTitle: failure.title,
            submitErrorMessage: failure.message,
          ),
        );

        debugPrint(
          '================================================================',
        );

        return false;
      },
      (_) async {
        debugPrint('✓ createAcademicVerificationRequest success');

        emit(
          state.copyWith(
            submitStatus: AcademicVerificationSubmitStatus.success,
            submitSuccessTitle: '! تمت العملية بنجاح',
            submitSuccessMessage: 'تم إرسال طلب التوثيق الأكاديمي بنجاح',
            clearCertificateImagePath: true,
            clearIdentityImagePath: true,
          ),
        );

        final isRefreshed = await refresh();

        debugPrint('→ isRefreshed: $isRefreshed');
        debugPrint(
          '================================================================',
        );

        return true;
      },
    );
  }

  Future<bool> cancelRequest() async {
    debugPrint(
      '============ AcademicVerificationCubit.cancelRequest ============',
    );

    if (state.isCancelLoading) {
      debugPrint('→ cancel already in progress');
      debugPrint(
        '================================================================',
      );
      return false;
    }

    final verification = state.verification;

    if (verification == null) {
      debugPrint('✗ verification data is null');

      emit(
        state.copyWith(
          cancelStatus: AcademicVerificationCancelStatus.failure,
          cancelErrorTitle: 'تعذر إلغاء الطلب',
          cancelErrorMessage: 'بيانات طلب التوثيق غير متوفرة حاليًا.',
        ),
      );

      debugPrint(
        '================================================================',
      );

      return false;
    }

    if (!verification.hasRequest) {
      debugPrint('✗ no active verification request');

      emit(
        state.copyWith(
          cancelStatus: AcademicVerificationCancelStatus.failure,
          cancelErrorTitle: 'تعذر إلغاء الطلب',
          cancelErrorMessage: 'لا يوجد طلب توثيق أكاديمي حالي لإلغائه.',
        ),
      );

      debugPrint(
        '================================================================',
      );

      return false;
    }

    if (verification.remainingCancellations <= 0) {
      debugPrint('✗ no remaining cancellations');

      emit(
        state.copyWith(
          cancelStatus: AcademicVerificationCancelStatus.failure,
          cancelErrorTitle: 'تعذر إلغاء الطلب',
          cancelErrorMessage: 'لقد استنفدت جميع مرات إلغاء طلب التوثيق.',
        ),
      );

      debugPrint(
        '================================================================',
      );

      return false;
    }

    emit(
      state.copyWith(
        cancelStatus: AcademicVerificationCancelStatus.loading,
        clearCancelMessage: true,
      ),
    );

    final result = await cancelAcademicVerificationRequestUseCase();

    return await result.fold(
      (failure) async {
        debugPrint('✗ cancelAcademicVerificationRequest failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            cancelStatus: AcademicVerificationCancelStatus.failure,
            cancelErrorTitle: failure.title,
            cancelErrorMessage: failure.message,
          ),
        );

        debugPrint(
          '================================================================',
        );

        return false;
      },
      (_) async {
        debugPrint('✓ cancelAcademicVerificationRequest success');

        emit(
          state.copyWith(
            cancelStatus: AcademicVerificationCancelStatus.success,
            cancelSuccessTitle: '! تمت العملية بنجاح',
            cancelSuccessMessage: 'تم إلغاء طلب التوثيق الأكاديمي بنجاح',
          ),
        );

        final isRefreshed = await refresh();

        debugPrint('→ isRefreshed: $isRefreshed');
        debugPrint(
          '================================================================',
        );

        return true;
      },
    );
  }

  Future<bool> updateCertificateVisibility(bool showCertificatePublicly) async {
    debugPrint(
      '============ AcademicVerificationCubit.updateCertificateVisibility ============',
    );
    debugPrint('→ showCertificatePublicly: $showCertificatePublicly');
    debugPrint('→ api value: ${showCertificatePublicly ? 1 : 0}');

    if (state.isVisibilityLoading) {
      debugPrint('→ visibility update already in progress');
      debugPrint(
        '============================================================================',
      );
      return false;
    }

    final verification = state.verification;

    if (verification == null) {
      debugPrint('✗ verification data is null');

      emit(
        state.copyWith(
          visibilityStatus: AcademicVerificationVisibilityStatus.failure,
          visibilityErrorTitle: 'تعذر تحديث الإعداد',
          visibilityErrorMessage: 'بيانات التوثيق الأكاديمي غير متوفرة حاليًا.',
        ),
      );

      debugPrint(
        '============================================================================',
      );

      return false;
    }

    if (!verification.isApproved) {
      debugPrint('✗ academic verification is not approved');

      emit(
        state.copyWith(
          visibilityStatus: AcademicVerificationVisibilityStatus.failure,
          visibilityErrorTitle: 'تعذر تحديث الإعداد',
          visibilityErrorMessage:
              'لا يمكن تغيير ظهور الشهادة قبل الموافقة على طلب التوثيق.',
        ),
      );

      debugPrint(
        '============================================================================',
      );

      return false;
    }

    if (verification.showCertificatePublicly == showCertificatePublicly) {
      debugPrint('→ visibility value has not changed');
      debugPrint(
        '============================================================================',
      );

      return true;
    }

    emit(
      state.copyWith(
        visibilityStatus: AcademicVerificationVisibilityStatus.loading,
        clearVisibilityMessage: true,
      ),
    );

    final result = await updateAcademicVerificationVisibilityUseCase(
      UpdateAcademicVerificationVisibilityParams(
        showCertificatePublicly: showCertificatePublicly,
      ),
    );

    return result.fold(
      (failure) {
        debugPrint('✗ updateAcademicVerificationVisibility failure');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            visibilityStatus: AcademicVerificationVisibilityStatus.failure,
            visibilityErrorTitle: failure.title,
            visibilityErrorMessage: failure.message,
          ),
        );

        debugPrint(
          '============================================================================',
        );

        return false;
      },
      (_) {
        debugPrint('✓ updateAcademicVerificationVisibility success');

        emit(
          state.copyWith(
            visibilityStatus: AcademicVerificationVisibilityStatus.success,
            verification: verification.copyWith(
              showCertificatePublicly: showCertificatePublicly,
            ),
            clearVisibilityMessage: true,
          ),
        );

        debugPrint(
          '→ local visibility updated: '
          '$showCertificatePublicly',
        );
        debugPrint(
          '============================================================================',
        );

        return true;
      },
    );
  }

  ////////////////////////////////////
  void resetSubmitStatus() {
    debugPrint(
      '============ AcademicVerificationCubit.resetSubmitStatus ============',
    );

    emit(
      state.copyWith(
        submitStatus: AcademicVerificationSubmitStatus.initial,
        clearSubmitMessage: true,
      ),
    );

    debugPrint('✓ submit status reset');
    debugPrint(
      '====================================================================',
    );
  }

  void resetCancelStatus() {
    debugPrint(
      '============ AcademicVerificationCubit.resetCancelStatus ============',
    );

    emit(
      state.copyWith(
        cancelStatus: AcademicVerificationCancelStatus.initial,
        clearCancelMessage: true,
      ),
    );

    debugPrint('✓ cancel status reset');
    debugPrint(
      '====================================================================',
    );
  }

  void resetVisibilityStatus() {
    debugPrint(
      '============ AcademicVerificationCubit.resetVisibilityStatus ============',
    );

    emit(
      state.copyWith(
        visibilityStatus: AcademicVerificationVisibilityStatus.initial,
        clearVisibilityMessage: true,
      ),
    );

    debugPrint('✓ visibility status reset');
    debugPrint(
      '=========================================================================',
    );
  }
  
}
