import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/create_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/delete_study_task_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/change_study_task_status_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/create_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/delete_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/toggle_study_sub_task_status_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/update_study_task_params.dart';

abstract class StudyTaskRepository {
  Future<Either<Failure, StudyTaskDetailsEntity>> getStudyTaskDetails({
    required GetStudyTaskDetailsParams params,
  });

  Future<Either<Failure, CreateStudyTaskResponseEntity>> createStudyTask({
    required CreateStudyTaskParams params,
  });

  Future<Either<Failure, StudyPlanSubjectsResponseEntity>>
  getStudyPlanSubjects({required int planId});

  Future<Either<Failure, CreateStudyTaskResponseEntity>> updateStudyTask({
    required UpdateStudyTaskParams params,
  });

  Future<Either<Failure, DeleteStudyTaskResponseEntity>> deleteStudyTask({
    required DeleteStudyTaskParams params,
  });

  Future<Either<Failure, CreateStudyTaskResponseEntity>> changeStudyTaskStatus({
    required ChangeStudyTaskStatusParams params,
  });

  Future<Either<Failure, CreateStudyTaskResponseEntity>>
  toggleStudySubTaskStatus({required ToggleStudySubTaskStatusParams params});
}
