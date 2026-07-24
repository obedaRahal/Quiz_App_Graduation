import 'package:quiz_app_grad/features/settings/domain/entity/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.taskRemindersEnabled,
    required super.weekStartsOn,
    required super.timeFormat,
    required super.themeMode,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      taskRemindersEnabled: _parseBoolean(json['task_reminders_enabled']),
      weekStartsOn: _parseString(json['week_starts_on']),
      timeFormat: _parseString(json['time_format']),
      themeMode: _parseString(json['theme_mode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_reminders_enabled': taskRemindersEnabled,
      'week_starts_on': weekStartsOn,
      'time_format': timeFormat,
      'theme_mode': themeMode,
    };
  }

  static bool _parseBoolean(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalizedValue = value.trim().toLowerCase();

      return normalizedValue == 'true' || normalizedValue == '1';
    }

    return false;
  }

  static String _parseString(dynamic value) {
    return value?.toString().trim() ?? '';
  }
}
