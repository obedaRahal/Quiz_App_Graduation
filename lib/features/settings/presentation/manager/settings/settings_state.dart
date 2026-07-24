import 'package:quiz_app_grad/features/settings/domain/entity/settings_entity.dart';

class SettingsState {
  final bool isLoading;

  final SettingsEntity? settings;

  final String? errorTitle;
  final String? errorMessage;

  final bool isTogglingTaskReminders;
  final bool isUpdatingTheme;
  final bool isUpdatingDateTime;
  final bool isUpdatingPassword;
  final bool isLoggingOut;

  const SettingsState({
    this.isLoading = false,
    this.settings,
    this.errorTitle,
    this.errorMessage,
    this.isTogglingTaskReminders = false,
    this.isUpdatingTheme = false,
    this.isUpdatingDateTime = false,
    this.isUpdatingPassword = false,
    this.isLoggingOut = false,
  });

  bool get hasSettings => settings != null;

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  SettingsState copyWith({
    bool? isLoading,
    SettingsEntity? settings,
    bool clearSettings = false,

    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    bool? isTogglingTaskReminders,
    bool? isUpdatingTheme,
    bool? isUpdatingDateTime,
    bool? isUpdatingPassword,
    bool? isLoggingOut,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,

      settings: clearSettings ? null : settings ?? this.settings,

      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      isTogglingTaskReminders:
          isTogglingTaskReminders ?? this.isTogglingTaskReminders,

      isUpdatingTheme: isUpdatingTheme ?? this.isUpdatingTheme,

      isUpdatingDateTime: isUpdatingDateTime ?? this.isUpdatingDateTime,

      isUpdatingPassword: isUpdatingPassword ?? this.isUpdatingPassword,

      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }
}
