import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';

abstract class StudyAlarmRepository {
  Future<Either<Failure, StudyAlarmScheduleEntity>> getStudyAlarmSchedule();
}
