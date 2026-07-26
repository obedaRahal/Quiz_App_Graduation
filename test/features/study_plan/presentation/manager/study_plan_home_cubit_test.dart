import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/services/app_date_time_settings.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_overview_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_daily_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_daily_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/change_study_task_status_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGetStudyPlanDailyOverviewUseCase extends Mock
    implements GetStudyPlanDailyOverviewUseCase {}

class MockChangeStudyTaskStatusUseCase extends Mock
    implements ChangeStudyTaskStatusUseCase {}

class FakeGetStudyPlanDailyOverviewParams extends Fake
    implements GetStudyPlanDailyOverviewParams {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetStudyPlanDailyOverviewUseCase getOverview;
  late StudyPlanHomeCubit cubit;

  setUpAll(() async {
    registerFallbackValue(FakeGetStudyPlanDailyOverviewParams());
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  setUp(() async {
    await AppDateTimeSettings.save(
      weekStartsOn: 'الثلاثاء',
      timeFormat: '12 ساعة',
    );

    getOverview = MockGetStudyPlanDailyOverviewUseCase();
    cubit = StudyPlanHomeCubit(
      getStudyPlanDailyOverviewUseCase: getOverview,
      changeStudyTaskStatusUseCase: MockChangeStudyTaskStatusUseCase(),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test(
    'keeps the requested Tuesday to Monday range when API returns Saturday',
    () async {
      final response = StudyPlanOverviewModel.fromJson({
        'success': true,
        'title': 'تم',
        'status_code': 200,
        'data': {
          'userSettings': {
            'id': 1,
            'week_starts_on': 'السبت',
            'time_format': '24 ساعة',
          },
          'server_today': '2026-07-26',
          'selected_date': '2026-07-26',
          'range': {'start': '2026-07-25', 'end': '2026-07-31'},
          'has_default_plan': false,
          'days': [
            {
              'date': '2026-07-26',
              'day_number': 26,
              'day_name': 'الأحد',
              'is_today': true,
              'has_tasks': true,
              'total_tasks': 2,
              'completed_tasks': 1,
              'completion_state': 'incompleted',
              'display_state': 'today',
            },
          ],
          'tasks': <Map<String, dynamic>>[],
        },
      });

      when(() => getOverview(any())).thenAnswer((_) async => Right(response));

      await cubit.getDailyOverview(
        date: DateTime(2026, 7, 26),
        rangeStart: DateTime(2026, 7, 21),
        rangeEnd: DateTime(2026, 7, 27),
        clearPreviousData: true,
      );

      final capturedParams =
          verify(() => getOverview(captureAny())).captured.single
              as GetStudyPlanDailyOverviewParams;

      expect(capturedParams.date, '2026-07-26');
      expect(capturedParams.rangeStart, '2026-07-21');
      expect(capturedParams.rangeEnd, '2026-07-27');
      expect(cubit.state.rangeStart, '2026-07-21');
      expect(cubit.state.rangeEnd, '2026-07-27');
      expect(cubit.state.weekStartsOn, 'الثلاثاء');
      expect(cubit.state.days, hasLength(7));
      expect(cubit.state.days.first.date, '2026-07-21');
      expect(cubit.state.days.last.date, '2026-07-27');
      expect(
        cubit.state.days
            .singleWhere((day) => day.date == '2026-07-26')
            .hasTasks,
        isTrue,
      );
    },
  );

  test(
    'refresh recalculates the range after the cached week start changes',
    () async {
      final response = StudyPlanOverviewModel.fromJson({
        'success': true,
        'data': {
          'server_today': '2026-07-26',
          'selected_date': '2026-07-26',
          'range': {'start': '2026-07-25', 'end': '2026-07-31'},
          'days': <Map<String, dynamic>>[],
          'tasks': <Map<String, dynamic>>[],
        },
      });
      when(() => getOverview(any())).thenAnswer((_) async => Right(response));

      await AppDateTimeSettings.save(
        weekStartsOn: 'السبت',
        timeFormat: '12 ساعة',
      );
      await cubit.getDailyOverview(
        date: DateTime(2026, 7, 26),
        rangeStart: DateTime(2026, 7, 25),
        rangeEnd: DateTime(2026, 7, 31),
        clearPreviousData: true,
      );

      await AppDateTimeSettings.save(
        weekStartsOn: 'الثلاثاء',
        timeFormat: '12 ساعة',
      );
      await cubit.refreshOverview();

      final capturedCalls = verify(() => getOverview(captureAny())).captured;
      final refreshedParams =
          capturedCalls.last as GetStudyPlanDailyOverviewParams;

      expect(refreshedParams.rangeStart, '2026-07-21');
      expect(refreshedParams.rangeEnd, '2026-07-27');
      expect(cubit.state.days.first.date, '2026-07-21');
      expect(cubit.state.days.last.date, '2026-07-27');
    },
  );

  test('reads user settings from the snake case API key', () {
    final response = StudyPlanOverviewModel.fromJson({
      'data': {
        'user_settings': {
          'week_starts_on': 'الثلاثاء',
          'time_format': '24 ساعة',
        },
      },
    });

    expect(response.data.userSettings.weekStartsOn, 'الثلاثاء');
    expect(response.data.userSettings.timeFormat, '24 ساعة');
  });
}
