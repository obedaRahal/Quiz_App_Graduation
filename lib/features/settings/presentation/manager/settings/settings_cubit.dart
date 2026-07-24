import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/disable_task_reminders_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/enable_task_reminders_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/get_settings_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/logout_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/logout_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_date_time_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/update_password_params.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_date_time_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_password_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;

  final EnableTaskRemindersUseCase enableTaskRemindersUseCase;

  final DisableTaskRemindersUseCase disableTaskRemindersUseCase;

  final UpdateThemeModeUseCase updateThemeModeUseCase;

  final UpdateDateTimeUseCase updateDateTimeUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final LogoutUseCase logoutUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.enableTaskRemindersUseCase,
    required this.disableTaskRemindersUseCase,
    required this.updateThemeModeUseCase,

    required this.updateDateTimeUseCase,
    required this.updatePasswordUseCase,
    required this.logoutUseCase,
  }) : super(const SettingsState()) {
    debugPrint('============ SettingsCubit INIT ============');
  }

  Future<void> getSettings() async {
    if (state.isLoading) {
      debugPrint('============ SettingsCubit.getSettings skipped ============');
      debugPrint('→ reason: settings already loading');
      debugPrint('===========================================================');
      return;
    }

    debugPrint('============ SettingsCubit.getSettings ============');

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await getSettingsUseCase();

    if (isClosed) {
      return;
    }

    result.fold(
      (failure) {
        debugPrint('✗ getSettings failed');
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
      (settings) {
        debugPrint('✓ getSettings success');

        debugPrint(
          '→ taskRemindersEnabled: '
          '${settings.taskRemindersEnabled}',
        );

        debugPrint('→ weekStartsOn: ${settings.weekStartsOn}');

        debugPrint('→ timeFormat: ${settings.timeFormat}');

        debugPrint('→ themeMode: ${settings.themeMode}');

        emit(
          state.copyWith(
            isLoading: false,
            settings: settings,
            clearError: true,
          ),
        );
      },
    );

    debugPrint('===================================================');
  }

  void clearError() {
    if (!state.hasError) {
      return;
    }

    debugPrint('============ SettingsCubit.clearError ============');

    emit(state.copyWith(clearError: true));

    debugPrint('==================================================');
  }

  Future<bool> toggleTaskReminders() async {
    debugPrint("============ SettingsCubit.toggleTaskReminders ============");

    if (state.isTogglingTaskReminders) {
      debugPrint("→ toggleTaskReminders skipped: already loading");

      return false;
    }

    final currentSettings = state.settings;

    if (currentSettings == null) {
      debugPrint("→ toggleTaskReminders skipped: settings is null");

      return false;
    }

    final currentValue = currentSettings.taskRemindersEnabled;

    final newValue = !currentValue;

    debugPrint("→ currentValue: $currentValue");
    debugPrint("→ newValue: $newValue");

    emit(state.copyWith(isTogglingTaskReminders: true, clearError: true));

    final result = newValue
        ? await enableTaskRemindersUseCase()
        : await disableTaskRemindersUseCase();

    return result.fold(
      (failure) {
        debugPrint("× toggleTaskReminders failure");

        if (!isClosed) {
          emit(
            state.copyWith(
              isTogglingTaskReminders: false,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }

        return false;
      },
      (_) {
        debugPrint("√ toggleTaskReminders success");

        debugPrint("→ taskRemindersEnabled: $newValue");

        if (!isClosed) {
          emit(
            state.copyWith(
              isTogglingTaskReminders: false,
              settings: currentSettings.copyWith(
                taskRemindersEnabled: newValue,
              ),
              clearError: true,
            ),
          );
        }

        return true;
      },
    );
  }

  Future<bool> updateThemeMode({required String themeMode}) async {
    debugPrint("============ SettingsCubit.updateThemeMode ============");

    if (state.isUpdatingTheme) {
      debugPrint("→ updateThemeMode skipped: already loading");

      return false;
    }

    final currentSettings = state.settings;

    if (currentSettings == null) {
      debugPrint("→ updateThemeMode skipped: settings is null");

      return false;
    }

    final normalizedThemeMode = themeMode.trim();

    if (normalizedThemeMode != 'ليلي' && normalizedThemeMode != 'نهاري') {
      debugPrint("→ updateThemeMode skipped: invalid theme mode");

      return false;
    }

    if (currentSettings.themeMode.trim() == normalizedThemeMode) {
      debugPrint("→ updateThemeMode skipped: same theme mode");

      return true;
    }

    debugPrint("→ currentThemeMode: ${currentSettings.themeMode}");

    debugPrint("→ newThemeMode: $normalizedThemeMode");

    emit(state.copyWith(isUpdatingTheme: true, clearError: true));

    final result = await updateThemeModeUseCase(themeMode: normalizedThemeMode);

    return result.fold(
      (failure) {
        debugPrint("× updateThemeMode failure");

        if (!isClosed) {
          emit(
            state.copyWith(
              isUpdatingTheme: false,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }

        return false;
      },
      (_) {
        debugPrint("√ updateThemeMode success");

        debugPrint("→ themeMode: $normalizedThemeMode");

        if (!isClosed) {
          emit(
            state.copyWith(
              isUpdatingTheme: false,
              settings: currentSettings.copyWith(
                themeMode: normalizedThemeMode,
              ),
              clearError: true,
            ),
          );
        }

        return true;
      },
    );
  }

  Future<bool> updateDateTime({
    required String weekStartsOn,
    required String timeFormat,
  }) async {
    debugPrint("============ SettingsCubit.updateDateTime ============");

    if (state.isUpdatingDateTime) {
      debugPrint("→ skipped: already loading");
      return false;
    }

    final currentSettings = state.settings;

    if (currentSettings == null) {
      debugPrint("→ skipped: settings is null");
      return false;
    }

    final normalizedWeekStartsOn = weekStartsOn.trim();
    final normalizedTimeFormat = timeFormat.trim();

    const allowedDays = {
      'الأحد',
      'الإتنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
    };

    const allowedTimeFormats = {'12 ساعة', '24 ساعة'};

    if (!allowedDays.contains(normalizedWeekStartsOn)) {
      debugPrint("→ skipped: invalid weekStartsOn");
      return false;
    }

    if (!allowedTimeFormats.contains(normalizedTimeFormat)) {
      debugPrint("→ skipped: invalid timeFormat");
      return false;
    }

    final hasSameValues =
        currentSettings.weekStartsOn.trim() == normalizedWeekStartsOn &&
        currentSettings.timeFormat.trim() == normalizedTimeFormat;

    if (hasSameValues) {
      debugPrint("→ skipped: same date/time settings");
      return true;
    }

    emit(state.copyWith(isUpdatingDateTime: true, clearError: true));

    final result = await updateDateTimeUseCase(
      params: UpdateDateTimeParams(
        weekStartsOn: normalizedWeekStartsOn,
        timeFormat: normalizedTimeFormat,
      ),
    );

    return result.fold(
      (failure) {
        debugPrint("× updateDateTime failure");

        if (!isClosed) {
          emit(
            state.copyWith(
              isUpdatingDateTime: false,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }

        return false;
      },
      (_) {
        debugPrint("√ updateDateTime success");

        if (!isClosed) {
          emit(
            state.copyWith(
              isUpdatingDateTime: false,
              settings: currentSettings.copyWith(
                weekStartsOn: normalizedWeekStartsOn,
                timeFormat: normalizedTimeFormat,
              ),
              clearError: true,
            ),
          );
        }

        return true;
      },
    );
  }

  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    debugPrint("============ SettingsCubit.updatePassword ============");

    if (state.isUpdatingPassword) {
      debugPrint("→ skipped: already loading");
      return false;
    }

    final normalizedOldPassword = oldPassword.trim();
    final normalizedNewPassword = newPassword.trim();
    final normalizedConfirmation = newPasswordConfirmation.trim();

    if (normalizedOldPassword.isEmpty ||
        normalizedNewPassword.isEmpty ||
        normalizedConfirmation.isEmpty) {
      debugPrint("→ skipped: empty password field");

      emit(
        state.copyWith(
          errorTitle: 'بيانات غير مكتملة',
          errorMessage: 'يرجى تعبئة جميع حقول كلمة المرور',
        ),
      );

      return false;
    }

    if (normalizedNewPassword != normalizedConfirmation) {
      debugPrint("→ skipped: passwords do not match");

      emit(
        state.copyWith(
          errorTitle: 'كلمتا المرور غير متطابقتين',
          errorMessage: 'يرجى التأكد من تطابق كلمة المرور الجديدة وتأكيدها',
        ),
      );

      return false;
    }

    emit(state.copyWith(isUpdatingPassword: true, clearError: true));

    final result = await updatePasswordUseCase(
      params: UpdatePasswordParams(
        oldPassword: normalizedOldPassword,
        newPassword: normalizedNewPassword,
        newPasswordConfirmation: normalizedConfirmation,
      ),
    );

    return result.fold(
      (failure) {
        debugPrint("× updatePassword failure");

        if (!isClosed) {
          emit(
            state.copyWith(
              isUpdatingPassword: false,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }

        return false;
      },
      (_) {
        debugPrint("√ updatePassword success");

        if (!isClosed) {
          emit(state.copyWith(isUpdatingPassword: false, clearError: true));
        }

        return true;
      },
    );
  }

  Future<bool> logout({
    required String? fcmToken,
    required String? deviceId,
  }) async {
    debugPrint("============ SettingsCubit.logout ============");

    if (state.isLoggingOut) {
      debugPrint("→ skipped: already loading");
      return false;
    }

    emit(state.copyWith(isLoggingOut: true, clearError: true));

    final result = await logoutUseCase(
      params: LogoutParams(fcmToken: fcmToken, deviceId: deviceId),
    );

    return result.fold(
      (failure) {
        debugPrint("× logout failure");

        if (!isClosed) {
          emit(
            state.copyWith(
              isLoggingOut: false,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        }

        return false;
      },
      (_) {
        debugPrint("√ logout API success");

        if (!isClosed) {
          emit(state.copyWith(isLoggingOut: false, clearError: true));
        }

        return true;
      },
    );
  }
}
