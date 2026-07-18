import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/create_update/create_study_plan_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/delete_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_tasks_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plans_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_action_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/create_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_subject_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_daily_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_tasks_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/update_study_plan_params.dart';

abstract class StudyPlanRepository {
  Future<Either<Failure, StudyPlanOverviewEntity>> getDailyTasksOverview({
    required GetStudyPlanDailyOverviewParams params,
  });

  Future<Either<Failure, StudySubjectsResponseEntity>> getStudySubjects();

  Future<Either<Failure, StudySubjectActionResponseEntity>> createStudySubject({
    required CreateStudySubjectParams params,
  });

  Future<Either<Failure, StudySubjectActionResponseEntity>> deleteStudySubject({
    required DeleteStudySubjectParams params,
  });

  Future<Either<Failure, CreateStudyPlanResponseEntity>> createStudyPlan({
    required CreateStudyPlanParams params,
  });

  Future<Either<Failure, StudyPlansResponseEntity>> getStudyPlans({
    required GetStudyPlansParams params,
  });

  Future<Either<Failure, StudyPlanDetailsOverviewEntity>>
  getStudyPlanDetailsOverview({
    required GetStudyPlanDetailsOverviewParams params,
  });

  Future<Either<Failure, StudyPlanDetailsTasksEntity>>
  getStudyPlanDetailsTasks({required GetStudyPlanDetailsTasksParams params});

  Future<Either<Failure, CreateStudyPlanResponseEntity>> updateStudyPlan({
    required UpdateStudyPlanParams params,
  });

  Future<Either<Failure, DeleteStudyPlanEntity>> deleteStudyPlan(
    DeleteStudyPlanParams params,
  );
}
