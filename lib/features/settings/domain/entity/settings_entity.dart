class SettingsEntity {
  final bool taskRemindersEnabled;
  final String weekStartsOn;
  final String timeFormat;
  final String themeMode;

  const SettingsEntity({
    required this.taskRemindersEnabled,
    required this.weekStartsOn,
    required this.timeFormat,
    required this.themeMode,
  });

  SettingsEntity copyWith({
    bool? taskRemindersEnabled,
    String? weekStartsOn,
    String? timeFormat,
    String? themeMode,
  }) {
    return SettingsEntity(
      taskRemindersEnabled: taskRemindersEnabled ?? this.taskRemindersEnabled,
      weekStartsOn: weekStartsOn ?? this.weekStartsOn,
      timeFormat: timeFormat ?? this.timeFormat,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
