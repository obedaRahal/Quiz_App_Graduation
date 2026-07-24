import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/settings_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/disable_task_reminders_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/enable_task_reminders_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/get_settings_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/logout_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_date_time_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_password_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/update_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/settings/settings_cubit.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/use_cases/get_study_alarm_schedule_use_case.dart';
import 'package:quiz_app_grad/features/study_alarm/services/study_alarm_scheduler_service.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockEnableTaskRemindersUseCase extends Mock
    implements EnableTaskRemindersUseCase {}

class MockDisableTaskRemindersUseCase extends Mock
    implements DisableTaskRemindersUseCase {}

class MockUpdateThemeModeUseCase extends Mock
    implements UpdateThemeModeUseCase {}

class MockUpdateDateTimeUseCase extends Mock implements UpdateDateTimeUseCase {}

class MockUpdatePasswordUseCase extends Mock implements UpdatePasswordUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetStudyAlarmScheduleUseCase extends Mock
    implements GetStudyAlarmScheduleUseCase {}

class MockStudyAlarmSchedulerService extends Mock
    implements StudyAlarmSchedulerService {}

void main() {
  late MockGetSettingsUseCase getSettings;
  late MockEnableTaskRemindersUseCase enableReminders;
  late MockDisableTaskRemindersUseCase disableReminders;
  late MockGetStudyAlarmScheduleUseCase getSchedule;
  late MockStudyAlarmSchedulerService scheduler;

  const disabledSettings = SettingsEntity(
    taskRemindersEnabled: false,
    weekStartsOn: 'الأحد',
    timeFormat: '24 ساعة',
    themeMode: 'نهاري',
  );
  const enabledSettings = SettingsEntity(
    taskRemindersEnabled: true,
    weekStartsOn: 'الأحد',
    timeFormat: '24 ساعة',
    themeMode: 'نهاري',
  );
  final schedule = StudyAlarmScheduleEntity(
    timezone: 'Asia/Damascus',
    taskRemindersEnabled: true,
    shouldCancelExistingAlarms: false,
    days: 7,
    generatedAt: DateTime.utc(2026, 7, 24),
    alarms: const [],
  );

  SettingsCubit buildCubit() {
    return SettingsCubit(
      getSettingsUseCase: getSettings,
      enableTaskRemindersUseCase: enableReminders,
      disableTaskRemindersUseCase: disableReminders,
      updateThemeModeUseCase: MockUpdateThemeModeUseCase(),
      updateDateTimeUseCase: MockUpdateDateTimeUseCase(),
      updatePasswordUseCase: MockUpdatePasswordUseCase(),
      logoutUseCase: MockLogoutUseCase(),
      getStudyAlarmScheduleUseCase: getSchedule,
      studyAlarmSchedulerService: scheduler,
    );
  }

  setUp(() {
    getSettings = MockGetSettingsUseCase();
    enableReminders = MockEnableTaskRemindersUseCase();
    disableReminders = MockDisableTaskRemindersUseCase();
    getSchedule = MockGetStudyAlarmScheduleUseCase();
    scheduler = MockStudyAlarmSchedulerService();
  });

  test(
    'enabling reminders updates the server then syncs device alarms',
    () async {
      when(
        () => getSettings(),
      ).thenAnswer((_) async => const Right(disabledSettings));
      when(() => enableReminders()).thenAnswer((_) async => const Right(unit));
      when(() => getSchedule()).thenAnswer((_) async => Right(schedule));
      when(
        () => scheduler.syncStudyAlarms(schedule: schedule),
      ).thenAnswer((_) async {});

      final cubit = buildCubit();
      await cubit.getSettings();

      final succeeded = await cubit.setTaskRemindersEnabled(enabled: true);

      expect(succeeded, isTrue);
      expect(cubit.state.settings?.taskRemindersEnabled, isTrue);
      verifyInOrder([
        () => enableReminders(),
        () => getSchedule(),
        () => scheduler.syncStudyAlarms(schedule: schedule),
      ]);
      await cubit.close();
    },
  );

  test('disabling reminders cancels all device alarms', () async {
    when(
      () => getSettings(),
    ).thenAnswer((_) async => const Right(enabledSettings));
    when(() => disableReminders()).thenAnswer((_) async => const Right(unit));
    when(() => scheduler.cancelAllStudyAlarms()).thenAnswer((_) async {});

    final cubit = buildCubit();
    await cubit.getSettings();

    final succeeded = await cubit.setTaskRemindersEnabled(enabled: false);

    expect(succeeded, isTrue);
    expect(cubit.state.settings?.taskRemindersEnabled, isFalse);
    verifyInOrder([
      () => disableReminders(),
      () => scheduler.cancelAllStudyAlarms(),
    ]);
    await cubit.close();
  });
}
