import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';

abstract class StudyTaskRepository {
  Future<Either<Failure, StudyTaskDetailsEntity>> getStudyTaskDetails({
    required GetStudyTaskDetailsParams params,
  });
}
