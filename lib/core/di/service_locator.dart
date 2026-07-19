import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_app_grad/core/services/accessibility/test_voice_assistant_service.dart';
import 'package:quiz_app_grad/core/services/deep_link/deep_link_service.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/core/services/file_picker_service_impl.dart';
import 'package:quiz_app_grad/core/services/file_picker/core/services/file_picker_service.dart';
import 'package:quiz_app_grad/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:quiz_app_grad/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_request_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_reset_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_verify_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/login_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/verify_email_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_cubit.dart';
import 'package:quiz_app_grad/features/content_details/data/datasources/my_content_details_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/data/datasources/other_content_bookmark_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/data/datasources/other_content_details_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/data/datasources/other_content_like_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/data/datasources/other_content_report_remote_data_source.dart';
import 'package:quiz_app_grad/features/content_details/data/repositories/my_content_details_repository_impl.dart';
import 'package:quiz_app_grad/features/content_details/data/repositories/other_content_bookmark_repository_impl.dart';
import 'package:quiz_app_grad/features/content_details/data/repositories/other_content_details_repository_impl.dart';
import 'package:quiz_app_grad/features/content_details/data/repositories/other_content_like_repository_impl.dart';
import 'package:quiz_app_grad/features/content_details/data/repositories/other_content_report_repository_impl.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/my_content_details_repository.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_bookmark_repository.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_details_repository.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_like_repository.dart';
import 'package:quiz_app_grad/features/content_details/domain/repositories/other_content_report_repository.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/bookmark_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/download_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/follow_publisher_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/get_other_content_details_usecase.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/get_similar_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/like_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/my_content_details/delete_my_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/my_content_details/get_my_public_content_details_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/report_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/unbookmark_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/unfollow_publisher_use_case.dart';
import 'package:quiz_app_grad/features/content_details/domain/usecases/unlike_other_content_use_case.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';
import 'package:quiz_app_grad/features/create_test/data/datasource/create_test_remote_data_source.dart';
import 'package:quiz_app_grad/features/create_test/data/repositories/create_test_repository_impl.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/create_content_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/create_manual_test_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_ai_question_generation_status_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_editable_test_questions_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_scientific_classifications_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/start_ai_question_generation_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/update_content_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/update_test_use_case.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/data/data_sources/details_of_test_remote_data_source.dart';
import 'package:quiz_app_grad/features/details_of_test/data/repo_impl/details_of_test_repository_impl.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/repositories/details_of_test_repository.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/add_feedback_on_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/add_test_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/bookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/create_stripe_checkout_session_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/delete_feedback_on_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/delete_test_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/download_test_file_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_reviews_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_other_test_details_sample_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_shared_test_link_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_test_interaction_users_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_test_share_link_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/like_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/submit_report_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unbookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unlike_test_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/update_test_review_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_cubit.dart';
import 'package:quiz_app_grad/features/get_all_interests/data/data_source/all_interests_remote_data_source.dart';
import 'package:quiz_app_grad/features/get_all_interests/data/repositories/all_interests_repository_impl.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/repositories/all_interests_repository.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/use_case/get_all_interests_use_case.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_cubit.dart';
import 'package:quiz_app_grad/features/home/data/datasource/home_remote_data_source.dart';
import 'package:quiz_app_grad/features/home/data/repositories/home_repo_impl.dart';
import 'package:quiz_app_grad/features/home/domain/repositories/home_repostory.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommanded_test_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_interests_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_users_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/data/datasource/laboratory_remote_data_source.dart';
import 'package:quiz_app_grad/features/laboratory/data/repositories/laboratory_repository_impl.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/filter_tests_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_ai_generation_daily_limit_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_lab_recommended_tests_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/search_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/library/data/datasources/library_remote_data_source.dart';
import 'package:quiz_app_grad/features/library/data/repositories/library_repository_impl.dart';
import 'package:quiz_app_grad/features/library/domain/repositories/library_repository.dart';
import 'package:quiz_app_grad/features/library/domain/usecases/get_library_content_usecase.dart';
import 'package:quiz_app_grad/features/library/domain/usecases/search_library_content_usecase.dart';
import 'package:quiz_app_grad/features/library/presentation/manager/library_cubit/library_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/data/data_source/my_profile_remote_data_source.dart';
import 'package:quiz_app_grad/features/my_profile/data/repo_impl/my_profile_repository_impl.dart';
import 'package:quiz_app_grad/features/my_profile/domain/repository/my_profile_repository.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/create_my_profile_folder_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/delete_my_profile_folder_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/delete_my_profile_picture_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_academic_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_personal_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_picture_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/edit_my_profile_scientific_interests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_%5Bicker_search_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_bookmarks_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_folder_content_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_folders_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_library_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_picker_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/filter_my_profile_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/get_my_profile_personal_info_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/search_my_profile_library_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/update_my_profile_folder_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/data/data_sources/my_public_test_details_remote_data_source.dart';
import 'package:quiz_app_grad/features/my_test_details/data/repo_impl/my_public_test_details_repository_impl.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/repository/my_public_test_details_repository.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/delete_my_test_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_private_test_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_public_test_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_public_test_reviews_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_public_test_status_history_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/use_cases/get_my_test_modifications_use_case.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:quiz_app_grad/features/onboarding/data/repository_impl/onboarding_repository_impl.dart';
import 'package:quiz_app_grad/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_interests_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_progress_preview_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_current_university_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_discovery_source_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_education_level_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_graduate_academic_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_school_stage_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_user_interests_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/data/data_source/other_profile_remote_data_source.dart';
import 'package:quiz_app_grad/features/other_profile/data/repo_impl/other_profile_repository_impl.dart';
import 'package:quiz_app_grad/features/other_profile/domain/repository/other_profile_repository.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_content_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_folder_details_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_folders_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_overview_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_tests_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_academic_certificate_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_connections_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_receive_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_share_link_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_overview_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/remove_content_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/remove_folder_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/save_content_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/save_folder_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_connections/other_profile_connections_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/settings/data/data_source/theme_local_data_source.dart';
import 'package:quiz_app_grad/features/settings/data/repository_impl/theme_repository_impl.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/theme_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/get_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/set_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/data/data_sources/study_plan_remote_data_source.dart';
import 'package:quiz_app_grad/features/study_plan/data/repo_impl/study_plan_repository_impl.dart';
import 'package:quiz_app_grad/features/study_plan/domain/repositories/study_plan_repository.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/create_study_plan_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/create_study_subject_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/delete_study_plan_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/delete_study_subject_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_daily_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_details_tasks_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plans_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_subjects_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/update_study_plan_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_cubit.dart';
import 'package:quiz_app_grad/features/study_task/data/data_sources/study_task_remote_data_source.dart';
import 'package:quiz_app_grad/features/study_task/data/repo_impl/study_task_repository_impl.dart';
import 'package:quiz_app_grad/features/study_task/domain/repositories/study_task_repository.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/get_study_task_details_use_case.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/data_sources/test_play_modes_remote_data_source.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/repo_impl/test_play_modes_repository_impl.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/services/challenge_result_pdf_service.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/services/mcq_result_pdf_service.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/repositories/test_play_modes_repository.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/get_test_play_content_use_case.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/register_test_attempt_interaction_use_case.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/tests_by_interest/data/data_source/tests_by_interest_remote_data_source.dart';
import 'package:quiz_app_grad/features/tests_by_interest/data/repositories/tests_by_interest_repository_impl.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/repositories/tests_by_interest_repository.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/use_cases/search_tests_by_interest_use_case.dart'
    as tests_by_interest_search;
import 'package:quiz_app_grad/features/tests_by_interest/presentation/manager/tests_by_interest_cubit/tests_by_interest_cubit.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/use_cases/get_tests_by_interest_use_case.dart'
    as tests_by_interest;

import '../database/api/api_consumer.dart';
import '../database/api/dio_consumer.dart';
import '../database/api/end_point.dart';
import '../database/cache/token_storage.dart';
import '../utils/auth_session.dart';

final sl = GetIt.instance;

Future<void> initSl() async {
  await _registerCore();
  _registerThemeFeature();
  _registerOnboardingFeature();
  _registerFilePickerFeature();
  _registerAuthFeature();
  _registerDetailsOfTestFeature();
  _registerTestsByInterestFeature();
  _registerTestPlayModeFeature();
  _registerCreateTestFeature();

  _registerMyTestDetailsFeature();
  _registerOtherProfileFeature();
  _registerLibraryFeature();
  _registerMyProfileFeature();

  _registerStudyPlanFeature();
  _registerStudyTaskFeature();
}

Future<void> _registerCore() async {
  if (!sl.isRegistered<AuthSession>()) {
    sl.registerLazySingleton<AuthSession>(() => AuthSession());
  }

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ),
    );
  }

  if (!sl.isRegistered<ApiConsumer>()) {
    sl.registerLazySingleton<ApiConsumer>(
      () => DioConsumer(
        dio: sl<Dio>(),
        getAccessToken: TokenStorage.getAccessToken,
        isTokenExpiringSoon: () => TokenStorage.isAccessTokenExpiringSoon(
          buffer: const Duration(minutes: 2),
        ),
        refreshToken: () => sl<AuthRepository>().refreshAccessToken(),
        clearSession: () async {
          await TokenStorage.clear();
          sl<AuthSession>().markUnauthenticated();
        },
      ),
    );
  }

  if (!sl.isRegistered<Dio>(instanceName: 'refresh_dio')) {
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      ),
      instanceName: 'refresh_dio',
    );
  }

  if (!sl.isRegistered<DeepLinkService>()) {
    sl.registerLazySingleton<DeepLinkService>(() => DeepLinkService());
  }

  if (!sl.isRegistered<TestVoiceAssistantService>()) {
    sl.registerLazySingleton<TestVoiceAssistantService>(
      () => TestVoiceAssistantService(),
    );
  }

  if (!sl.isRegistered<McqResultPdfService>()) {
    sl.registerLazySingleton<McqResultPdfService>(() => McqResultPdfService());
  }

  sl.registerLazySingleton<ChallengeResultPdfService>(
    () => ChallengeResultPdfService(),
  );
}

void _registerThemeFeature() {
  if (!sl.isRegistered<ThemeLocalDataSource>()) {
    sl.registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(),
    );
  }

  if (!sl.isRegistered<ThemeRepository>()) {
    sl.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(localDataSource: sl<ThemeLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<GetThemeModeUseCase>()) {
    sl.registerLazySingleton<GetThemeModeUseCase>(
      () => GetThemeModeUseCase(sl<ThemeRepository>()),
    );
  }

  if (!sl.isRegistered<SetThemeModeUseCase>()) {
    sl.registerLazySingleton<SetThemeModeUseCase>(
      () => SetThemeModeUseCase(sl<ThemeRepository>()),
    );
  }

  if (!sl.isRegistered<ThemeCubit>()) {
    sl.registerFactory<ThemeCubit>(
      () => ThemeCubit(
        getThemeModeUseCase: sl<GetThemeModeUseCase>(),
        setThemeModeUseCase: sl<SetThemeModeUseCase>(),
      ),
    );
  }
}

void _registerDetailsOfTestFeature() {
  if (!sl.isRegistered<DetailsOfTestRemoteDataSource>()) {
    sl.registerLazySingleton<DetailsOfTestRemoteDataSource>(
      () =>
          DetailsOfTestRemoteDataSourceImpl(apiConsumer: sl(), dio: sl<Dio>()),
    );
  }

  if (!sl.isRegistered<DetailsOfTestRepository>()) {
    sl.registerLazySingleton<DetailsOfTestRepository>(
      () => DetailsOfTestRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetOtherTestDetailsOverviewUseCase>()) {
    sl.registerLazySingleton<GetOtherTestDetailsOverviewUseCase>(
      () => GetOtherTestDetailsOverviewUseCase(sl<DetailsOfTestRepository>()),
    );
  }
  if (!sl.isRegistered<SubmitReportUseCase>()) {
    sl.registerLazySingleton<SubmitReportUseCase>(
      () => SubmitReportUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<GetTestShareLinkUseCase>()) {
    sl.registerLazySingleton<GetTestShareLinkUseCase>(
      () => GetTestShareLinkUseCase(sl<DetailsOfTestRepository>()),
    );
  }
  if (!sl.isRegistered<DetailsOfTestCubit>()) {
    sl.registerFactory<DetailsOfTestCubit>(
      () => DetailsOfTestCubit(
        getOtherTestDetailsOverviewUseCase:
            sl<GetOtherTestDetailsOverviewUseCase>(),
        getOtherTestDetailsSampleUseCase:
            sl<GetOtherTestDetailsSampleUseCase>(),
        getOtherTestDetailsReviewsUseCase:
            sl<GetOtherTestDetailsReviewsUseCase>(),
        likeTestUseCase: sl<LikeTestUseCase>(),
        unlikeTestUseCase: sl<UnlikeTestUseCase>(),
        bookmarkTestUseCase: sl<BookmarkTestUseCase>(),
        unbookmarkTestUseCase: sl<UnbookmarkTestUseCase>(),
        followCreatorUseCase: sl<FollowCreatorUseCase>(),
        unfollowCreatorUseCase: sl<UnfollowCreatorUseCase>(),
        downloadTestFileUseCase: sl<DownloadTestFileUseCase>(),
        addTestReviewUseCase: sl<AddTestReviewUseCase>(),
        updateTestReviewUseCase: sl<UpdateTestReviewUseCase>(),
        deleteTestReviewUseCase: sl<DeleteTestReviewUseCase>(),
        addFeedbackOnReviewUseCase: sl<AddFeedbackOnReviewUseCase>(),
        deleteFeedbackOnReviewUseCase: sl<DeleteFeedbackOnReviewUseCase>(),
        submitReportUseCase: sl<SubmitReportUseCase>(),
        getTestShareLinkUseCase: sl<GetTestShareLinkUseCase>(),
        getSharedTestLinkUseCase: sl<GetSharedTestLinkUseCase>(),
        createStripeCheckoutSessionUseCase:
            sl<CreateStripeCheckoutSessionUseCase>(),
      ),
    );
  }

  if (!sl.isRegistered<GetOtherTestDetailsSampleUseCase>()) {
    sl.registerLazySingleton<GetOtherTestDetailsSampleUseCase>(
      () => GetOtherTestDetailsSampleUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<GetOtherTestDetailsReviewsUseCase>()) {
    sl.registerLazySingleton<GetOtherTestDetailsReviewsUseCase>(
      () => GetOtherTestDetailsReviewsUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<LikeTestUseCase>()) {
    sl.registerLazySingleton<LikeTestUseCase>(
      () => LikeTestUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<UnlikeTestUseCase>()) {
    sl.registerLazySingleton<UnlikeTestUseCase>(
      () => UnlikeTestUseCase(sl<DetailsOfTestRepository>()),
    );
  }
  if (!sl.isRegistered<BookmarkTestUseCase>()) {
    sl.registerLazySingleton<BookmarkTestUseCase>(
      () => BookmarkTestUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<UnbookmarkTestUseCase>()) {
    sl.registerLazySingleton<UnbookmarkTestUseCase>(
      () => UnbookmarkTestUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  sl.registerLazySingleton(() => FollowCreatorUseCase(sl()));

  sl.registerLazySingleton(() => UnfollowCreatorUseCase(sl()));

  if (!sl.isRegistered<DownloadTestFileUseCase>()) {
    sl.registerLazySingleton<DownloadTestFileUseCase>(
      () => DownloadTestFileUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  sl.registerLazySingleton(() => AddTestReviewUseCase(sl()));

  if (!sl.isRegistered<UpdateTestReviewUseCase>()) {
    sl.registerLazySingleton<UpdateTestReviewUseCase>(
      () => UpdateTestReviewUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteTestReviewUseCase>()) {
    sl.registerLazySingleton<DeleteTestReviewUseCase>(
      () => DeleteTestReviewUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<AddFeedbackOnReviewUseCase>()) {
    sl.registerLazySingleton<AddFeedbackOnReviewUseCase>(
      () => AddFeedbackOnReviewUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteFeedbackOnReviewUseCase>()) {
    sl.registerLazySingleton<DeleteFeedbackOnReviewUseCase>(
      () => DeleteFeedbackOnReviewUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitReportUseCase>()) {
    sl.registerLazySingleton<SubmitReportUseCase>(
      () => SubmitReportUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<GetTestShareLinkUseCase>()) {
    sl.registerLazySingleton<GetTestShareLinkUseCase>(
      () => GetTestShareLinkUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<GetSharedTestLinkUseCase>()) {
    sl.registerLazySingleton<GetSharedTestLinkUseCase>(
      () => GetSharedTestLinkUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<TestInteractionUsersCubit>()) {
    sl.registerFactory<TestInteractionUsersCubit>(
      () => TestInteractionUsersCubit(
        getTestInteractionUsersUseCase: sl<GetTestInteractionUsersUseCase>(),
        followCreatorUseCase: sl<FollowCreatorUseCase>(),
        unfollowCreatorUseCase: sl<UnfollowCreatorUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<GetTestInteractionUsersUseCase>()) {
    sl.registerLazySingleton<GetTestInteractionUsersUseCase>(
      () => GetTestInteractionUsersUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<CreateStripeCheckoutSessionUseCase>()) {
    sl.registerLazySingleton<CreateStripeCheckoutSessionUseCase>(
      () => CreateStripeCheckoutSessionUseCase(sl<DetailsOfTestRepository>()),
    );
  }
}

void _registerTestPlayModeFeature() {
  if (!sl.isRegistered<TestPlayModesCubit>()) {
    sl.registerFactory<TestPlayModesCubit>(
      () => TestPlayModesCubit(
        voiceAssistantService: sl(),
        mcqResultPdfService: sl(),
        getTestPlayContentUseCase: sl<GetTestPlayContentUseCase>(),
        challengeResultPdfService: sl(),
        registerTestAttemptInteractionUseCase:
            sl<RegisterTestAttemptInteractionUseCase>(),
      ),
    );

    if (!sl.isRegistered<TestPlayModesRemoteDataSource>()) {
      sl.registerLazySingleton<TestPlayModesRemoteDataSource>(
        () => TestPlayModesRemoteDataSourceImpl(apiConsumer: sl()),
      );
    }

    if (!sl.isRegistered<TestPlayModesRepository>()) {
      sl.registerLazySingleton<TestPlayModesRepository>(
        () => TestPlayModesRepositoryImpl(remoteDataSource: sl()),
      );
    }

    if (!sl.isRegistered<GetTestPlayContentUseCase>()) {
      sl.registerLazySingleton<GetTestPlayContentUseCase>(
        () => GetTestPlayContentUseCase(sl<TestPlayModesRepository>()),
      );
    }

    if (!sl.isRegistered<RegisterTestAttemptInteractionUseCase>()) {
      sl.registerLazySingleton<RegisterTestAttemptInteractionUseCase>(
        () => RegisterTestAttemptInteractionUseCase(
          sl<TestPlayModesRepository>(),
        ),
      );
    }

    if (!sl.isRegistered<TestPlayModesCubit>()) {
      sl.registerFactory<TestPlayModesCubit>(
        () => TestPlayModesCubit(
          voiceAssistantService: sl(),
          mcqResultPdfService: sl(),
          getTestPlayContentUseCase: sl<GetTestPlayContentUseCase>(),
          challengeResultPdfService: sl(),
          registerTestAttemptInteractionUseCase:
              sl<RegisterTestAttemptInteractionUseCase>(),
        ),
      );
    }
  }
}

void _registerOnboardingFeature() {
  if (!sl.isRegistered<OnboardingRemoteDataSource>()) {
    sl.registerLazySingleton<OnboardingRemoteDataSource>(
      () => OnboardingRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(
        remoteDataSource: sl<OnboardingRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<SubmitDiscoverySourceUseCase>()) {
    sl.registerLazySingleton<SubmitDiscoverySourceUseCase>(
      () => SubmitDiscoverySourceUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitEducationLevelUseCase>()) {
    sl.registerLazySingleton<SubmitEducationLevelUseCase>(
      () => SubmitEducationLevelUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitSchoolStageUseCase>()) {
    sl.registerLazySingleton<SubmitSchoolStageUseCase>(
      () => SubmitSchoolStageUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitCurrentUniversityProfileUseCase>()) {
    sl.registerLazySingleton<SubmitCurrentUniversityProfileUseCase>(
      () => SubmitCurrentUniversityProfileUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitGraduateAcademicProfileUseCase>()) {
    sl.registerLazySingleton<SubmitGraduateAcademicProfileUseCase>(
      () => SubmitGraduateAcademicProfileUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<GetOnboardingInterestsUseCase>()) {
    sl.registerLazySingleton<GetOnboardingInterestsUseCase>(
      () => GetOnboardingInterestsUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitUserInterestsUseCase>()) {
    sl.registerLazySingleton<SubmitUserInterestsUseCase>(
      () => SubmitUserInterestsUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<GetOnboardingProgressPreviewUseCase>()) {
    sl.registerLazySingleton<GetOnboardingProgressPreviewUseCase>(
      () => GetOnboardingProgressPreviewUseCase(sl<OnboardingRepository>()),
    );
  }
}

void _registerFilePickerFeature() {
  if (!sl.isRegistered<FilePickerService>()) {
    sl.registerLazySingleton<FilePickerService>(() => FilePickerServiceImpl());
  }
}

void _registerAuthFeature() {
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
        refreshDio: sl<Dio>(instanceName: 'refresh_dio'),
      ),
    );
  }

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () =>
          AuthRepositoryImpl(authRemoteDataSource: sl<AuthRemoteDataSource>()),
    );
  }

  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<RegisterCubit>()) {
    sl.registerFactory<RegisterCubit>(
      () => RegisterCubit(sl<RegisterUseCase>()),
    );
  }
  if (!sl.isRegistered<VerifyEmailUseCase>()) {
    sl.registerLazySingleton<VerifyEmailUseCase>(
      () => VerifyEmailUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<VerifyRegisterCubit>()) {
    sl.registerFactory<VerifyRegisterCubit>(
      () => VerifyRegisterCubit(
        verifyEmailUseCase: sl<VerifyEmailUseCase>(),
        resendOtpUseCase: sl<ResendOtpUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<VerifyEmailUseCase>()) {
    sl.registerLazySingleton<VerifyEmailUseCase>(
      () => VerifyEmailUseCase(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<LoginCubit>()) {
    sl.registerFactory<LoginCubit>(
      () => LoginCubit(
        loginUseCase: sl<LoginUseCase>(),
        resendOtpUseCase: sl<ResendOtpUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<ResendOtpUseCase>()) {
    sl.registerLazySingleton<ResendOtpUseCase>(
      () => ResendOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<VerifyRegisterCubit>()) {
    sl.registerFactory<VerifyRegisterCubit>(
      () => VerifyRegisterCubit(
        verifyEmailUseCase: sl<VerifyEmailUseCase>(),
        resendOtpUseCase: sl<ResendOtpUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<ForgotPasswordRequestOtpUseCase>()) {
    sl.registerLazySingleton<ForgotPasswordRequestOtpUseCase>(
      () => ForgotPasswordRequestOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<ForgotPasswordVerifyOtpUseCase>()) {
    sl.registerLazySingleton<ForgotPasswordVerifyOtpUseCase>(
      () => ForgotPasswordVerifyOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<ForgetPasswordCubit>()) {
    sl.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(
        forgotPasswordRequestOtpUseCase: sl<ForgotPasswordRequestOtpUseCase>(),
        forgotPasswordVerifyOtpUseCase: sl<ForgotPasswordVerifyOtpUseCase>(),
        forgotPasswordResendOtpUseCase: sl<ForgotPasswordResendOtpUseCase>(),
        forgotPasswordResetUseCase: sl<ForgotPasswordResetUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<ForgotPasswordResendOtpUseCase>()) {
    sl.registerLazySingleton<ForgotPasswordResendOtpUseCase>(
      () => ForgotPasswordResendOtpUseCase(sl<AuthRepository>()),
    );
  }
  if (!sl.isRegistered<ForgotPasswordResetUseCase>()) {
    sl.registerLazySingleton<ForgotPasswordResetUseCase>(
      () => ForgotPasswordResetUseCase(sl<AuthRepository>()),
    );
  }
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(api: sl()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetRecommendedTestsUseCase(sl()));
  sl.registerLazySingleton(() => GetRecommendedInterestsUseCase(sl()));
  sl.registerLazySingleton(() => GetRecommendedUsersUseCase(sl()));

  sl.registerLazySingleton<AllInterestsRepository>(
    () => AllInterestsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetAllInterestsUseCase(sl()));
  // All Interests
  sl.registerLazySingleton<AllInterestsRemoteDataSource>(
    () => AllInterestsRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton<LaboratoryRemoteDataSource>(
    () => LaboratoryRemoteDataSourceImpl(api: sl()),
  );

  sl.registerLazySingleton<LaboratoryRepository>(
    () => LaboratoryRepositoryImpl(remoteDataSource: sl()),
  );
  if (!sl.isRegistered<GetLabRecommendedTestsUseCase>()) {
    sl.registerLazySingleton<GetLabRecommendedTestsUseCase>(
      () => GetLabRecommendedTestsUseCase(sl<LaboratoryRepository>()),
    );
  }
  if (!sl.isRegistered<GetAiGenerationDailyLimitUseCase>()) {
    sl.registerLazySingleton<GetAiGenerationDailyLimitUseCase>(
      () => GetAiGenerationDailyLimitUseCase(sl<LaboratoryRepository>()),
    );
  }
  if (!sl.isRegistered<FilterTestsUseCase>()) {
    sl.registerLazySingleton<FilterTestsUseCase>(
      () => FilterTestsUseCase(sl<LaboratoryRepository>()),
    );
  }

  if (!sl.isRegistered<GetTestsByInterestUseCase>()) {
    sl.registerLazySingleton<GetTestsByInterestUseCase>(
      () => GetTestsByInterestUseCase(sl<LaboratoryRepository>()),
    );
  }

  if (!sl.isRegistered<SearchTestsByInterestUseCase>()) {
    sl.registerLazySingleton<SearchTestsByInterestUseCase>(
      () => SearchTestsByInterestUseCase(sl<LaboratoryRepository>()),
    );
  }
}

void _registerTestsByInterestFeature() {
  if (!sl.isRegistered<TestsByInterestRemoteDataSource>()) {
    sl.registerLazySingleton<TestsByInterestRemoteDataSource>(
      () => TestsByInterestRemoteDataSourceImpl(apiConsumer: sl()),
    );
  }

  if (!sl.isRegistered<TestsByInterestRepository>()) {
    sl.registerLazySingleton<TestsByInterestRepository>(
      () => TestsByInterestRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<tests_by_interest.GetTestsByInterestUseCase>()) {
    sl.registerLazySingleton<tests_by_interest.GetTestsByInterestUseCase>(
      () => tests_by_interest.GetTestsByInterestUseCase(
        repository: sl<TestsByInterestRepository>(),
      ),
    );
  }

  if (!sl
      .isRegistered<tests_by_interest_search.SearchTestsByInterestUseCase>()) {
    sl.registerLazySingleton<
      tests_by_interest_search.SearchTestsByInterestUseCase
    >(
      () => tests_by_interest_search.SearchTestsByInterestUseCase(
        repository: sl<TestsByInterestRepository>(),
      ),
    );
  }
  if (!sl.isRegistered<TestsByInterestCubit>()) {
    sl.registerFactory<TestsByInterestCubit>(
      () => TestsByInterestCubit(
        getTestsByInterestUseCase:
            sl<tests_by_interest.GetTestsByInterestUseCase>(),
        searchTestsByInterestUseCase:
            sl<tests_by_interest_search.SearchTestsByInterestUseCase>(),
      ),
    );
  }
}

// ================= Create Test  =================
void _registerCreateTestFeature() {
  if (!sl.isRegistered<CreateTestRemoteDataSource>()) {
    sl.registerLazySingleton<CreateTestRemoteDataSource>(
      () => CreateTestRemoteDataSourceImpl(api: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<CreateTestRepository>()) {
    sl.registerLazySingleton<CreateTestRepository>(
      () => CreateTestRepositoryImpl(
        remoteDataSource: sl<CreateTestRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<GetScientificClassificationsUseCase>()) {
    sl.registerLazySingleton<GetScientificClassificationsUseCase>(
      () => GetScientificClassificationsUseCase(sl<CreateTestRepository>()),
    );
  }

  if (!sl.isRegistered<CreateManualTestUseCase>()) {
    sl.registerLazySingleton<CreateManualTestUseCase>(
      () => CreateManualTestUseCase(sl<CreateTestRepository>()),
    );
  }

  if (!sl.isRegistered<StartAiQuestionGenerationUseCase>()) {
    sl.registerLazySingleton<StartAiQuestionGenerationUseCase>(
      () => StartAiQuestionGenerationUseCase(sl<CreateTestRepository>()),
    );
  }

  if (!sl.isRegistered<GetAiQuestionGenerationStatusUseCase>()) {
    sl.registerLazySingleton<GetAiQuestionGenerationStatusUseCase>(
      () => GetAiQuestionGenerationStatusUseCase(sl<CreateTestRepository>()),
    );
  }

  if (!sl.isRegistered<GetEditableTestQuestionsUseCase>()) {
    sl.registerLazySingleton<GetEditableTestQuestionsUseCase>(
      () => GetEditableTestQuestionsUseCase(sl<CreateTestRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateTestUseCase>()) {
    sl.registerLazySingleton<UpdateTestUseCase>(
      () => UpdateTestUseCase(sl<CreateTestRepository>()),
    );
  }
  if (!sl.isRegistered<CreateContentUseCase>()) {
    sl.registerLazySingleton<CreateContentUseCase>(
      () => CreateContentUseCase(sl()),
    );
  }
  if (!sl.isRegistered<UpdateContentUseCase>()) {
    sl.registerLazySingleton<UpdateContentUseCase>(
      () => UpdateContentUseCase(sl<CreateTestRepository>()),
    );
  }
  if (!sl.isRegistered<CreateTestCubit>()) {
    sl.registerFactory<CreateTestCubit>(
      () => CreateTestCubit(
        getScientificClassificationsUseCase:
            sl<GetScientificClassificationsUseCase>(),
        createManualTestUseCase: sl<CreateManualTestUseCase>(),
        startAiQuestionGenerationUseCase:
            sl<StartAiQuestionGenerationUseCase>(),
        getAiQuestionGenerationStatusUseCase:
            sl<GetAiQuestionGenerationStatusUseCase>(),
        getEditableTestQuestionsUseCase: sl<GetEditableTestQuestionsUseCase>(),
        updateTestUseCase: sl<UpdateTestUseCase>(),
        createContentUseCase: sl<CreateContentUseCase>(),
        updateContentUseCase: sl<UpdateContentUseCase>(),
      ),
    );
  }
}
// void _registerCreateTestFeature() {
//   if (!sl.isRegistered<CreateTestRemoteDataSource>()) {
//     sl.registerLazySingleton<CreateTestRemoteDataSource>(
//       () => CreateTestRemoteDataSourceImpl(api: sl<ApiConsumer>()),
//     );
//   }

//   if (!sl.isRegistered<CreateTestRepository>()) {
//     sl.registerLazySingleton<CreateTestRepository>(
//       () => CreateTestRepositoryImpl(
//         remoteDataSource: sl<CreateTestRemoteDataSource>(),
//       ),
//     );
//   }

//   if (!sl.isRegistered<GetScientificClassificationsUseCase>()) {
//     sl.registerLazySingleton<GetScientificClassificationsUseCase>(
//       () => GetScientificClassificationsUseCase(sl<CreateTestRepository>()),
//     );
//     sl.registerLazySingleton<StartAiQuestionGenerationUseCase>(
//       () => StartAiQuestionGenerationUseCase(sl()),
//     );

//     sl.registerLazySingleton<GetAiQuestionGenerationStatusUseCase>(
//       () => GetAiQuestionGenerationStatusUseCase(sl()),
//     );
//   }
//   if (!sl.isRegistered<GetEditableTestQuestionsUseCase>()) {
//     sl.registerLazySingleton(() => GetEditableTestQuestionsUseCase(sl()));
//   }
//   if (!sl.isRegistered<UpdateTestUseCase>()) {
//     sl.registerLazySingleton(() => UpdateTestUseCase(sl()));
//   }
//   if (!sl.isRegistered<CreateTestCubit>()) {
//     sl.registerFactory<CreateTestCubit>(
//       () => CreateTestCubit(
//         getScientificClassificationsUseCase: sl(),
//         createManualTestUseCase: sl(),
//         startAiQuestionGenerationUseCase: sl(),
//         getAiQuestionGenerationStatusUseCase: sl(),
//         getEditableTestQuestionsUseCase: sl(),
//         updateTestUseCase: sl(),
//       ),
//     );
//   }
//   if (!sl.isRegistered<CreateManualTestUseCase>()) {
//     sl.registerLazySingleton<CreateManualTestUseCase>(
//       () => CreateManualTestUseCase(sl<CreateTestRepository>()),
//     );
//   }
// }

// ================= Library =================
void _registerLibraryFeature() {
  if (!sl.isRegistered<LibraryRemoteDataSource>()) {
    sl.registerLazySingleton<LibraryRemoteDataSource>(
      () => LibraryRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<LibraryRepository>()) {
    sl.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(
        remoteDataSource: sl<LibraryRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<GetLibraryContentUseCase>()) {
    sl.registerLazySingleton<GetLibraryContentUseCase>(
      () => GetLibraryContentUseCase(sl<LibraryRepository>()),
    );
  }
  if (!sl.isRegistered<SearchLibraryContentUseCase>()) {
    sl.registerLazySingleton<SearchLibraryContentUseCase>(
      () => SearchLibraryContentUseCase(sl<LibraryRepository>()),
    );
  }
  if (!sl.isRegistered<OtherContentLikeRemoteDataSource>()) {
    sl.registerLazySingleton<OtherContentLikeRemoteDataSource>(
      () =>
          OtherContentLikeRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<OtherContentLikeRepository>()) {
    sl.registerLazySingleton<OtherContentLikeRepository>(
      () => OtherContentLikeRepositoryImpl(
        remoteDataSource: sl<OtherContentLikeRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<LikeOtherContentUseCase>()) {
    sl.registerLazySingleton<LikeOtherContentUseCase>(
      () => LikeOtherContentUseCase(sl<OtherContentLikeRepository>()),
    );
  }

  if (!sl.isRegistered<UnlikeOtherContentUseCase>()) {
    sl.registerLazySingleton<UnlikeOtherContentUseCase>(
      () => UnlikeOtherContentUseCase(sl<OtherContentLikeRepository>()),
    );
  }
  if (!sl.isRegistered<LibraryCubit>()) {
    sl.registerFactory<LibraryCubit>(
      () => LibraryCubit(
        getLibraryContentUseCase: sl<GetLibraryContentUseCase>(),
        searchLibraryContentUseCase: sl<SearchLibraryContentUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<OtherContentDetailsRemoteDataSource>()) {
    sl.registerLazySingleton<OtherContentDetailsRemoteDataSource>(
      () => OtherContentDetailsRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<OtherContentDetailsRepository>()) {
    sl.registerLazySingleton<OtherContentDetailsRepository>(
      () => OtherContentDetailsRepositoryImpl(
        remoteDataSource: sl<OtherContentDetailsRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<GetOtherContentDetailsUseCase>()) {
    sl.registerLazySingleton<GetOtherContentDetailsUseCase>(
      () => GetOtherContentDetailsUseCase(sl<OtherContentDetailsRepository>()),
    );
  }
  //===================== Other Content Bookmark =====================//

  if (!sl.isRegistered<OtherContentBookmarkRemoteDataSource>()) {
    sl.registerLazySingleton<OtherContentBookmarkRemoteDataSource>(
      () => OtherContentBookmarkRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<OtherContentBookmarkRepository>()) {
    sl.registerLazySingleton<OtherContentBookmarkRepository>(
      () => OtherContentBookmarkRepositoryImpl(
        remoteDataSource: sl<OtherContentBookmarkRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<BookmarkOtherContentUseCase>()) {
    sl.registerLazySingleton<BookmarkOtherContentUseCase>(
      () => BookmarkOtherContentUseCase(sl<OtherContentBookmarkRepository>()),
    );
  }

  if (!sl.isRegistered<UnbookmarkOtherContentUseCase>()) {
    sl.registerLazySingleton<UnbookmarkOtherContentUseCase>(
      () => UnbookmarkOtherContentUseCase(sl<OtherContentBookmarkRepository>()),
    );
  }
  //===================== Other Content Report =====================//

  if (!sl.isRegistered<OtherContentReportRemoteDataSource>()) {
    sl.registerLazySingleton<OtherContentReportRemoteDataSource>(
      () => OtherContentReportRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<OtherContentReportRepository>()) {
    sl.registerLazySingleton<OtherContentReportRepository>(
      () => OtherContentReportRepositoryImpl(
        remoteDataSource: sl<OtherContentReportRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<ReportOtherContentUseCase>()) {
    sl.registerLazySingleton<ReportOtherContentUseCase>(
      () => ReportOtherContentUseCase(sl<OtherContentReportRepository>()),
    );
  }
  if (!sl.isRegistered<DownloadOtherContentUseCase>()) {
    sl.registerLazySingleton<DownloadOtherContentUseCase>(
      () => DownloadOtherContentUseCase(sl<OtherContentDetailsRepository>()),
    );
  }
  if (!sl.isRegistered<GetSimilarContentUseCase>()) {
    sl.registerLazySingleton<GetSimilarContentUseCase>(
      () => GetSimilarContentUseCase(sl<OtherContentDetailsRepository>()),
    );
  }
  if (!sl.isRegistered<FollowPublisherUseCase>()) {
    sl.registerLazySingleton<FollowPublisherUseCase>(
      () => FollowPublisherUseCase(sl<OtherContentDetailsRepository>()),
    );
  }
  if (!sl.isRegistered<UnfollowPublisherUseCase>()) {
    sl.registerLazySingleton<UnfollowPublisherUseCase>(
      () => UnfollowPublisherUseCase(sl<OtherContentDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<MyContentDetailsRemoteDataSource>()) {
    sl.registerLazySingleton<MyContentDetailsRemoteDataSource>(
      () => MyContentDetailsRemoteDataSourceImpl(apiConsumer: sl()),
    );
  }

  if (!sl.isRegistered<MyContentDetailsRepository>()) {
    sl.registerLazySingleton<MyContentDetailsRepository>(
      () => MyContentDetailsRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetMyPublicContentDetailsUseCase>()) {
    sl.registerLazySingleton<GetMyPublicContentDetailsUseCase>(
      () => GetMyPublicContentDetailsUseCase(sl()),
    );
  }
  if (!sl.isRegistered<DeleteMyContentUseCase>()) {
    sl.registerLazySingleton<DeleteMyContentUseCase>(
      () => DeleteMyContentUseCase(sl()),
    );
  }
  if (!sl.isRegistered<OtherContentDetailsCubit>()) {
    sl.registerFactory(
      () => OtherContentDetailsCubit(
        getOtherContentDetailsUseCase: sl(),
        likeOtherContentUseCase: sl(),
        unlikeOtherContentUseCase: sl(),
        bookmarkOtherContentUseCase: sl(),
        unbookmarkOtherContentUseCase: sl(),
        reportOtherContentUseCase: sl(),
        downloadOtherContentUseCase: sl(),
        getSimilarContentUseCase: sl(),
        followPublisherUseCase: sl<FollowPublisherUseCase>(),
        unfollowPublisherUseCase: sl<UnfollowPublisherUseCase>(),
        getMyPublicContentDetailsUseCase: sl(),
        deleteMyContentUseCase: sl(),
      ),
    );
  }
}

// ================= My Public Test Details =================
void _registerMyTestDetailsFeature() {
  if (!sl.isRegistered<MyPublicTestDetailsRemoteDataSource>()) {
    sl.registerLazySingleton<MyPublicTestDetailsRemoteDataSource>(
      () => MyPublicTestDetailsRemoteDataSourceImpl(apiConsumer: sl()),
    );
  }

  if (!sl.isRegistered<MyPublicTestDetailsRepository>()) {
    sl.registerLazySingleton<MyPublicTestDetailsRepository>(
      () => MyPublicTestDetailsRepositoryImpl(remoteDataSource: sl()),
    );
  }

  if (!sl.isRegistered<GetMyPublicTestDetailsOverviewUseCase>()) {
    sl.registerLazySingleton<GetMyPublicTestDetailsOverviewUseCase>(
      () => GetMyPublicTestDetailsOverviewUseCase(
        sl<MyPublicTestDetailsRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<GetMyPublicTestStatusHistoryUseCase>()) {
    sl.registerLazySingleton<GetMyPublicTestStatusHistoryUseCase>(
      () => GetMyPublicTestStatusHistoryUseCase(
        sl<MyPublicTestDetailsRepository>(),
      ),
    );
  }
  if (!sl.isRegistered<GetMyPublicTestReviewsUseCase>()) {
    sl.registerLazySingleton<GetMyPublicTestReviewsUseCase>(
      () => GetMyPublicTestReviewsUseCase(sl<MyPublicTestDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<GetMyTestModificationsUseCase>()) {
    sl.registerLazySingleton<GetMyTestModificationsUseCase>(
      () => GetMyTestModificationsUseCase(sl<MyPublicTestDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<GetMyPrivateTestDetailsOverviewUseCase>()) {
    sl.registerLazySingleton<GetMyPrivateTestDetailsOverviewUseCase>(
      () => GetMyPrivateTestDetailsOverviewUseCase(
        sl<MyPublicTestDetailsRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<DeleteMyTestUseCase>()) {
    sl.registerLazySingleton<DeleteMyTestUseCase>(
      () => DeleteMyTestUseCase(sl<MyPublicTestDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<GetMyPublicTestStatusHistoryUseCase>()) {
    sl.registerFactory<MyTestDetailsCubit>(
      () => MyTestDetailsCubit(
        getMyPublicTestDetailsOverviewUseCase:
            sl<GetMyPublicTestDetailsOverviewUseCase>(),
        getMyPublicTestStatusHistoryUseCase:
            sl<GetMyPublicTestStatusHistoryUseCase>(),
        getMyPublicTestReviewsUseCase: sl<GetMyPublicTestReviewsUseCase>(),
        addFeedbackOnReviewUseCase: sl<AddFeedbackOnReviewUseCase>(),
        deleteFeedbackOnReviewUseCase: sl<DeleteFeedbackOnReviewUseCase>(),
        downloadTestFileUseCase: sl<DownloadTestFileUseCase>(),
        getTestShareLinkUseCase: sl<GetTestShareLinkUseCase>(),
        getMyTestModificationsUseCase: sl<GetMyTestModificationsUseCase>(),
        getOverviewPrivateUseCase: sl<GetMyPrivateTestDetailsOverviewUseCase>(),
        deleteMyTestUseCase: sl<DeleteMyTestUseCase>(),
      ),
    );
  }

  if (!sl.isRegistered<MyTestDetailsCubit>()) {
    sl.registerFactory<MyTestDetailsCubit>(
      () => MyTestDetailsCubit(
        getMyPublicTestDetailsOverviewUseCase:
            sl<GetMyPublicTestDetailsOverviewUseCase>(),
        getMyPublicTestStatusHistoryUseCase:
            sl<GetMyPublicTestStatusHistoryUseCase>(),
        getMyPublicTestReviewsUseCase: sl<GetMyPublicTestReviewsUseCase>(),
        addFeedbackOnReviewUseCase: sl<AddFeedbackOnReviewUseCase>(),
        deleteFeedbackOnReviewUseCase: sl<DeleteFeedbackOnReviewUseCase>(),
        downloadTestFileUseCase: sl<DownloadTestFileUseCase>(),
        getTestShareLinkUseCase: sl<GetTestShareLinkUseCase>(),
        getMyTestModificationsUseCase: sl<GetMyTestModificationsUseCase>(),
        getOverviewPrivateUseCase: sl<GetMyPrivateTestDetailsOverviewUseCase>(),
        deleteMyTestUseCase: sl<DeleteMyTestUseCase>(),
      ),
    );
  }
}

// ================= Other Profile =================
void _registerOtherProfileFeature() {
  // 1. Remote Data Source
  if (!sl.isRegistered<OtherProfileRemoteDataSource>()) {
    sl.registerLazySingleton<OtherProfileRemoteDataSource>(
      () => OtherProfileRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  // 2. Repository
  if (!sl.isRegistered<OtherProfileRepository>()) {
    sl.registerLazySingleton<OtherProfileRepository>(
      () => OtherProfileRepositoryImpl(
        remoteDataSource: sl<OtherProfileRemoteDataSource>(),
      ),
    );
  }

  // 3. Use Case
  if (!sl.isRegistered<FetchOtherProfileOverviewUseCase>()) {
    sl.registerLazySingleton<FetchOtherProfileOverviewUseCase>(
      () => FetchOtherProfileOverviewUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchOtherProfileTestsUseCase>()) {
    sl.registerLazySingleton<FetchOtherProfileTestsUseCase>(
      () => FetchOtherProfileTestsUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchOtherProfileFoldersUseCase>()) {
    sl.registerLazySingleton<FetchOtherProfileFoldersUseCase>(
      () => FetchOtherProfileFoldersUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchOtherProfileContentUseCase>()) {
    sl.registerLazySingleton<FetchOtherProfileContentUseCase>(
      () => FetchOtherProfileContentUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FollowCreatorUseCase>()) {
    sl.registerLazySingleton<FollowCreatorUseCase>(
      () => FollowCreatorUseCase(sl()),
    );
  }

  if (!sl.isRegistered<UnfollowCreatorUseCase>()) {
    sl.registerLazySingleton<UnfollowCreatorUseCase>(
      () => UnfollowCreatorUseCase(sl()),
    );
  }

  if (!sl.isRegistered<SaveFolderBookmarkUseCase>()) {
    sl.registerLazySingleton<SaveFolderBookmarkUseCase>(
      () => SaveFolderBookmarkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<RemoveFolderBookmarkUseCase>()) {
    sl.registerLazySingleton<RemoveFolderBookmarkUseCase>(
      () => RemoveFolderBookmarkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<SaveContentBookmarkUseCase>()) {
    sl.registerLazySingleton<SaveContentBookmarkUseCase>(
      () => SaveContentBookmarkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<RemoveContentBookmarkUseCase>()) {
    sl.registerLazySingleton<RemoveContentBookmarkUseCase>(
      () => RemoveContentBookmarkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchOtherProfileFolderDetailsUseCase>()) {
    sl.registerLazySingleton<FetchOtherProfileFolderDetailsUseCase>(
      () => FetchOtherProfileFolderDetailsUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<GetOtherProfileShareLinkUseCase>()) {
    sl.registerLazySingleton<GetOtherProfileShareLinkUseCase>(
      () => GetOtherProfileShareLinkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<GetOtherProfileReceiveUseCase>()) {
    sl.registerLazySingleton<GetOtherProfileReceiveUseCase>(
      () => GetOtherProfileReceiveUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<GetOtherProfileConnectionsUseCase>()) {
    sl.registerLazySingleton<GetOtherProfileConnectionsUseCase>(
      () => GetOtherProfileConnectionsUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<OtherProfileConnectionsCubit>()) {
    sl.registerFactory<OtherProfileConnectionsCubit>(
      () => OtherProfileConnectionsCubit(
        getOtherProfileConnectionsUseCase: sl(),
        followCreatorUseCase: sl(),
        unfollowCreatorUseCase: sl(),
      ),
    );
  }

  if (!sl.isRegistered<GetOtherProfileAcademicCertificateUseCase>()) {
    sl.registerLazySingleton<GetOtherProfileAcademicCertificateUseCase>(
      () => GetOtherProfileAcademicCertificateUseCase(
        sl<OtherProfileRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<OtherProfileCubit>()) {
    sl.registerFactory<OtherProfileCubit>(
      () => OtherProfileCubit(
        fetchOtherProfileOverviewUseCase:
            sl<FetchOtherProfileOverviewUseCase>(),
        fetchOtherProfileTestsUseCase: sl<FetchOtherProfileTestsUseCase>(),
        fetchOtherProfileFoldersUseCase: sl<FetchOtherProfileFoldersUseCase>(),
        fetchOtherProfileContentUseCase: sl<FetchOtherProfileContentUseCase>(),
        followCreatorUseCase: sl<FollowCreatorUseCase>(),
        unfollowCreatorUseCase: sl<UnfollowCreatorUseCase>(),
        removeFolderBookmarkUseCase: sl<RemoveFolderBookmarkUseCase>(),
        saveFolderBookmarkUseCase: sl<SaveFolderBookmarkUseCase>(),
        saveContentBookmarkUseCase: sl<SaveContentBookmarkUseCase>(),
        removeContentBookmarkUseCase: sl<RemoveContentBookmarkUseCase>(),
        fetchOtherProfileFolderDetailsUseCase:
            sl<FetchOtherProfileFolderDetailsUseCase>(),

        getOtherProfileShareLinkUseCase: sl<GetOtherProfileShareLinkUseCase>(),
        getOtherProfileReceiveUseCase: sl<GetOtherProfileReceiveUseCase>(),

        getOtherProfileAcademicCertificateUseCase:
            sl<GetOtherProfileAcademicCertificateUseCase>(),
      ),
    );
  }
}

//////////////////// my profile //////////////////
void _registerMyProfileFeature() {
  if (!sl.isRegistered<AllInterestsCubit>()) {
    sl.registerFactory<AllInterestsCubit>(
      () => AllInterestsCubit(
        getAllInterestsUseCase: sl<GetAllInterestsUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<MyProfileRemoteDataSource>()) {
    sl.registerLazySingleton<MyProfileRemoteDataSource>(
      () => MyProfileRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<MyProfileRepository>()) {
    sl.registerLazySingleton<MyProfileRepository>(
      () => MyProfileRepositoryImpl(
        remoteDataSource: sl<MyProfileRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<GetMyProfilePersonalInfoUseCase>()) {
    sl.registerLazySingleton<GetMyProfilePersonalInfoUseCase>(
      () => GetMyProfilePersonalInfoUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<EditMyProfilePersonalInfoUseCase>()) {
    sl.registerLazySingleton<EditMyProfilePersonalInfoUseCase>(
      () => EditMyProfilePersonalInfoUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<EditMyProfileAcademicInfoUseCase>()) {
    sl.registerLazySingleton<EditMyProfileAcademicInfoUseCase>(
      () => EditMyProfileAcademicInfoUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<EditMyProfileScientificInterestsUseCase>()) {
    sl.registerLazySingleton<EditMyProfileScientificInterestsUseCase>(
      () => EditMyProfileScientificInterestsUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<EditMyProfilePictureUseCase>()) {
    sl.registerLazySingleton<EditMyProfilePictureUseCase>(
      () => EditMyProfilePictureUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteMyProfilePictureUseCase>()) {
    sl.registerLazySingleton<DeleteMyProfilePictureUseCase>(
      () => DeleteMyProfilePictureUseCase(sl<MyProfileRepository>()),
    );
  }
  if (!sl.isRegistered<FetchMyProfileBookmarksUseCase>()) {
    sl.registerLazySingleton<FetchMyProfileBookmarksUseCase>(
      () => FetchMyProfileBookmarksUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<RemoveContentBookmarkUseCase>()) {
    sl.registerLazySingleton<RemoveContentBookmarkUseCase>(
      () => RemoveContentBookmarkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<RemoveFolderBookmarkUseCase>()) {
    sl.registerLazySingleton<RemoveFolderBookmarkUseCase>(
      () => RemoveFolderBookmarkUseCase(sl<OtherProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UnbookmarkTestUseCase>()) {
    sl.registerLazySingleton<UnbookmarkTestUseCase>(
      () => UnbookmarkTestUseCase(sl<DetailsOfTestRepository>()),
    );
  }

  if (!sl.isRegistered<MyProfileBookmarksCubit>()) {
    sl.registerFactory<MyProfileBookmarksCubit>(
      () => MyProfileBookmarksCubit(
        fetchMyProfileBookmarksUseCase: sl<FetchMyProfileBookmarksUseCase>(),
        removeContentBookmarkUseCase: sl<RemoveContentBookmarkUseCase>(),
        removeFolderBookmarkUseCase: sl<RemoveFolderBookmarkUseCase>(),
        unbookmarkTestUseCase: sl<UnbookmarkTestUseCase>(),
      ),
    );
  }

  if (!sl.isRegistered<FetchMyProfileLibraryUseCase>()) {
    sl.registerLazySingleton<FetchMyProfileLibraryUseCase>(
      () => FetchMyProfileLibraryUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<SearchMyProfileLibraryUseCase>()) {
    sl.registerLazySingleton<SearchMyProfileLibraryUseCase>(
      () => SearchMyProfileLibraryUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchMyProfileFoldersUseCase>()) {
    sl.registerLazySingleton<FetchMyProfileFoldersUseCase>(
      () => FetchMyProfileFoldersUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchMyProfileFolderContentUseCase>()) {
    sl.registerLazySingleton<FetchMyProfileFolderContentUseCase>(
      () => FetchMyProfileFolderContentUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchMyProfilePickerTestsUseCase>()) {
    sl.registerLazySingleton<FetchMyProfilePickerTestsUseCase>(
      () => FetchMyProfilePickerTestsUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FetchMyProfilePickerSearchTestsUseCase>()) {
    sl.registerLazySingleton<FetchMyProfilePickerSearchTestsUseCase>(
      () => FetchMyProfilePickerSearchTestsUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<CreateMyProfileFolderUseCase>()) {
    sl.registerLazySingleton<CreateMyProfileFolderUseCase>(
      () => CreateMyProfileFolderUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateMyProfileFolderUseCase>()) {
    sl.registerLazySingleton<UpdateMyProfileFolderUseCase>(
      () => UpdateMyProfileFolderUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<MyProfileFolderEditorCubit>()) {
    sl.registerFactory<MyProfileFolderEditorCubit>(
      () => MyProfileFolderEditorCubit(
        fetchMyProfilePickerTestsUseCase:
            sl<FetchMyProfilePickerTestsUseCase>(),
        fetchMyProfilePickerSearchTestsUseCase:
            sl<FetchMyProfilePickerSearchTestsUseCase>(),
        createMyProfileFolderUseCase: sl<CreateMyProfileFolderUseCase>(),
        updateMyProfileFolderUseCase: sl<UpdateMyProfileFolderUseCase>(),
        fetchMyProfileFolderContentUseCase: sl(),
      ),
    );
  }

  if (!sl.isRegistered<DeleteMyProfileFolderUseCase>()) {
    sl.registerLazySingleton<DeleteMyProfileFolderUseCase>(
      () => DeleteMyProfileFolderUseCase(sl<MyProfileRepository>()),
    );
  }

  if (!sl.isRegistered<FilterMyProfileTestsUseCase>()) {
    sl.registerLazySingleton<FilterMyProfileTestsUseCase>(
      () => FilterMyProfileTestsUseCase(sl<MyProfileRepository>()),
    );
  }
  if (!sl.isRegistered<GetAllInterestsUseCase>()) {
    sl.registerLazySingleton<GetAllInterestsUseCase>(
      () => GetAllInterestsUseCase(sl<AllInterestsRepository>()),
    );
  }

  if (!sl.isRegistered<MyProfileCubit>()) {
    sl.registerFactory<MyProfileCubit>(
      () => MyProfileCubit(
        getMyProfilePersonalInfoUseCase: sl<GetMyProfilePersonalInfoUseCase>(),
        editMyProfilePersonalInfoUseCase:
            sl<EditMyProfilePersonalInfoUseCase>(),
        editMyProfileAcademicInfoUseCase:
            sl<EditMyProfileAcademicInfoUseCase>(),
        editMyProfileScientificInterestsUseCase:
            sl<EditMyProfileScientificInterestsUseCase>(),
        editMyProfilePictureUseCase: sl<EditMyProfilePictureUseCase>(),
        deleteMyProfilePictureUseCase: sl<DeleteMyProfilePictureUseCase>(),
        fetchMyProfileLibraryUseCase: sl<FetchMyProfileLibraryUseCase>(),
        searchMyProfileLibraryUseCase: sl<SearchMyProfileLibraryUseCase>(),
        fetchMyProfileFoldersUseCase: sl<FetchMyProfileFoldersUseCase>(),
        fetchMyProfileFolderContentUseCase:
            sl<FetchMyProfileFolderContentUseCase>(),
        deleteMyProfileFolderUseCase: sl<DeleteMyProfileFolderUseCase>(),
        fetchMyProfileTestsUseCase: sl<FetchMyProfilePickerTestsUseCase>(),
        searchMyProfileTestsUseCase:
            sl<FetchMyProfilePickerSearchTestsUseCase>(),

        filterMyProfileTestsUseCase: sl<FilterMyProfileTestsUseCase>(),

        getAllInterestsUseCase: sl<GetAllInterestsUseCase>(),
        getMyProfileShareLinkUseCase: sl<GetOtherProfileShareLinkUseCase>(),
      ),
    );
  }
}

void _registerStudyPlanFeature() {
  if (!sl.isRegistered<StudyPlanRemoteDataSource>()) {
    sl.registerLazySingleton<StudyPlanRemoteDataSource>(
      () => StudyPlanRemoteDataSourceImpl(apiConsumer: sl()),
    );
  }

  if (!sl.isRegistered<StudyPlanRepository>()) {
    sl.registerLazySingleton<StudyPlanRepository>(
      () => StudyPlanRepositoryImpl(
        remoteDataSource: sl<StudyPlanRemoteDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<GetStudyPlanDailyOverviewUseCase>()) {
    sl.registerLazySingleton<GetStudyPlanDailyOverviewUseCase>(
      () => GetStudyPlanDailyOverviewUseCase(sl<StudyPlanRepository>()),
    );
  }

  if (!sl.isRegistered<StudyPlanHomeCubit>()) {
    sl.registerFactory<StudyPlanHomeCubit>(
      () => StudyPlanHomeCubit(
        getStudyPlanDailyOverviewUseCase:
            sl<GetStudyPlanDailyOverviewUseCase>(),
      ),
    );
  }

  if (!sl.isRegistered<GetStudySubjectsUseCase>()) {
    sl.registerLazySingleton<GetStudySubjectsUseCase>(
      () => GetStudySubjectsUseCase(sl<StudyPlanRepository>()),
    );
  }

  if (!sl.isRegistered<CreateStudySubjectUseCase>()) {
    sl.registerLazySingleton<CreateStudySubjectUseCase>(
      () => CreateStudySubjectUseCase(sl<StudyPlanRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteStudySubjectUseCase>()) {
    sl.registerLazySingleton<DeleteStudySubjectUseCase>(
      () => DeleteStudySubjectUseCase(sl<StudyPlanRepository>()),
    );
  }

  if (!sl.isRegistered<StudySubjectsCubit>()) {
    sl.registerFactory<StudySubjectsCubit>(
      () => StudySubjectsCubit(
        getStudySubjectsUseCase: sl<GetStudySubjectsUseCase>(),
        createStudySubjectUseCase: sl<CreateStudySubjectUseCase>(),
        deleteStudySubjectUseCase: sl<DeleteStudySubjectUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<CreateUpdateStudyPlanCubit>()) {
    sl.registerFactory<CreateUpdateStudyPlanCubit>(
      () => CreateUpdateStudyPlanCubit(
        getStudySubjectsUseCase: sl<GetStudySubjectsUseCase>(),
        createStudyPlanUseCase: sl<CreateStudyPlanUseCase>(),
        updateStudyPlanUseCase: sl<UpdateStudyPlanUseCase>(),
        getStudyPlanDetailsOverviewUseCase:
            sl<GetStudyPlanDetailsOverviewUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<CreateStudyPlanUseCase>()) {
    sl.registerLazySingleton<CreateStudyPlanUseCase>(
      () => CreateStudyPlanUseCase(sl<StudyPlanRepository>()),
    );
  }
  if (!sl.isRegistered<UpdateStudyPlanUseCase>()) {
    sl.registerLazySingleton<UpdateStudyPlanUseCase>(
      () => UpdateStudyPlanUseCase(sl<StudyPlanRepository>()),
    );
  }
  if (!sl.isRegistered<GetStudyPlanDetailsOverviewUseCase>()) {
    sl.registerLazySingleton<GetStudyPlanDetailsOverviewUseCase>(
      () => GetStudyPlanDetailsOverviewUseCase(sl<StudyPlanRepository>()),
    );
  }

  if (!sl.isRegistered<GetStudyPlansUseCase>()) {
    sl.registerLazySingleton<GetStudyPlansUseCase>(
      () => GetStudyPlansUseCase(sl<StudyPlanRepository>()),
    );
  }
  if (!sl.isRegistered<ManageStudyPlansCubit>()) {
    sl.registerFactory<ManageStudyPlansCubit>(
      () => ManageStudyPlansCubit(
        getStudyPlansUseCase: sl<GetStudyPlansUseCase>(),
      ),
    );
  }

  if (!sl.isRegistered<GetStudyPlanDetailsOverviewUseCase>()) {
    sl.registerLazySingleton<GetStudyPlanDetailsOverviewUseCase>(
      () => GetStudyPlanDetailsOverviewUseCase(sl<StudyPlanRepository>()),
    );
  }
  sl.registerLazySingleton<DeleteStudyPlanUseCase>(
    () => DeleteStudyPlanUseCase(repository: sl<StudyPlanRepository>()),
  );

  sl.registerLazySingleton<GetStudyPlanDetailsTasksUseCase>(
    () => GetStudyPlanDetailsTasksUseCase(sl<StudyPlanRepository>()),
  );

  if (!sl.isRegistered<StudyPlanDetailsCubit>()) {
    sl.registerFactory<StudyPlanDetailsCubit>(
      () => StudyPlanDetailsCubit(
        getStudyPlanDetailsOverviewUseCase:
            sl<GetStudyPlanDetailsOverviewUseCase>(),
        getStudyPlanDetailsTasksUseCase: sl<GetStudyPlanDetailsTasksUseCase>(),
        deleteStudyPlanUseCase: sl<DeleteStudyPlanUseCase>(),
      ),
    );
  }
}

void _registerStudyTaskFeature() {
  sl.registerFactory<StudyTaskDetailsCubit>(
    () => StudyTaskDetailsCubit(
      getStudyTaskDetailsUseCase: sl<GetStudyTaskDetailsUseCase>(),
    ),
  );

  sl.registerLazySingleton<GetStudyTaskDetailsUseCase>(
    () => GetStudyTaskDetailsUseCase(sl<StudyTaskRepository>()),
  );

  sl.registerLazySingleton<StudyTaskRepository>(
    () => StudyTaskRepositoryImpl(
      remoteDataSource: sl<StudyTaskRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<StudyTaskRemoteDataSource>(
    () => StudyTaskRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
