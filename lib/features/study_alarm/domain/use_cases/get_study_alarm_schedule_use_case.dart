import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/repositories/study_alarm_repository.dart';

class GetStudyAlarmScheduleUseCase {
  final StudyAlarmRepository repository;

  const GetStudyAlarmScheduleUseCase({required this.repository});

  Future<Either<Failure, StudyAlarmScheduleEntity>> call() {
    debugPrint(
      "==============GetStudyAlarmScheduleUseCase.cal()=======================",
    );
    return repository.getStudyAlarmSchedule();
  }
}
