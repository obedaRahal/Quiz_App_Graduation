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
import 'package:quiz_app_grad/features/create_test/data/datasource/create_test_remote_data_source.dart';
import 'package:quiz_app_grad/features/create_test/data/repositories/create_test_repository_impl.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/create_manual_test_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_ai_question_generation_status_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/get_scientific_classifications_use_case.dart';
import 'package:quiz_app_grad/features/create_test/domain/use_case/start_ai_question_generation_use_case.dart';
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
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_lab_recommended_tests_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/search_tests_by_interest_use_case.dart';
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
import 'package:quiz_app_grad/features/settings/data/data_source/theme_local_data_source.dart';
import 'package:quiz_app_grad/features/settings/data/repository_impl/theme_repository_impl.dart';
import 'package:quiz_app_grad/features/settings/domain/repositories/theme_repository.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/get_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/set_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_cubit.dart';
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
import 'package:quiz_app_grad/features/tests_by_interest/presentation/managet/tests_by_interest_cubit/tests_by_interest_cubit.dart';
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
    sl.registerLazySingleton<StartAiQuestionGenerationUseCase>(
      () => StartAiQuestionGenerationUseCase(sl()),
    );

    sl.registerLazySingleton<GetAiQuestionGenerationStatusUseCase>(
      () => GetAiQuestionGenerationStatusUseCase(sl()),
    );
  }

  if (!sl.isRegistered<CreateTestCubit>()) {
    sl.registerFactory<CreateTestCubit>(
      () => CreateTestCubit(
        getScientificClassificationsUseCase: sl(),
        createManualTestUseCase: sl(),
        startAiQuestionGenerationUseCase: sl(),
        getAiQuestionGenerationStatusUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<CreateManualTestUseCase>()) {
    sl.registerLazySingleton<CreateManualTestUseCase>(
      () => CreateManualTestUseCase(sl<CreateTestRepository>()),
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
