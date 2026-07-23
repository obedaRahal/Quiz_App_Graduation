import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_alarm/data/data_sources/study_alarm_remote_data_source.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/repositories/study_alarm_repository.dart';

class StudyAlarmRepositoryImpl implements StudyAlarmRepository {
  final StudyAlarmRemoteDataSource remoteDataSource;

  const StudyAlarmRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, StudyAlarmScheduleEntity>>
  getStudyAlarmSchedule() async {
    debugPrint(
      '============ StudyAlarmRepositoryImpl.getStudyAlarmSchedule ============',
    );

    try {
      final schedule =
          await remoteDataSource.getStudyAlarmSchedule();

      debugPrint('✓ getStudyAlarmSchedule success');
      debugPrint('→ timezone: ${schedule.timezone}');
      debugPrint(
        '→ taskRemindersEnabled: '
        '${schedule.taskRemindersEnabled}',
      );
      debugPrint(
        '→ shouldCancelExistingAlarms: '
        '${schedule.shouldCancelExistingAlarms}',
      );
      debugPrint('→ days: ${schedule.days}');
      debugPrint(
        '→ generatedAt: ${schedule.generatedAt}',
      );
      debugPrint(
        '→ alarms count: ${schedule.alarms.length}',
      );
      debugPrint(
        '========================================================================',
      );

      return Right(schedule);
    } on ServerException catch (e) {
      debugPrint(
        '✗ getStudyAlarmSchedule ServerException',
      );
      debugPrint(
        '→ title: ${e.errorModel.errorTitle}',
      );
      debugPrint(
        '→ message: ${e.errorModel.errorMessage}',
      );
      debugPrint(
        '========================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        '✗ getStudyAlarmSchedule CacheException',
      );
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '========================================================================',
      );

      return Left(
        CacheFailure(
          title: 'خطأ محلي',
          message: e.errorMessage,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint(
        '✗ getStudyAlarmSchedule Unexpected error: $e',
      );
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '========================================================================',
      );

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب جدول منبهات المهام',
        ),
      );
    }
  }
}