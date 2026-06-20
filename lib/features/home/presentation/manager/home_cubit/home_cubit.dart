import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommanded_test_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_interests_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_users_use_case.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRecommendedTestsUseCase getRecommendedTestsUseCase;
  final GetRecommendedInterestsUseCase getRecommendedInterestsUseCase;
  final GetRecommendedUsersUseCase getRecommendedUsersUseCase;

  HomeCubit({
    required this.getRecommendedTestsUseCase,
    required this.getRecommendedInterestsUseCase,
    required this.getRecommendedUsersUseCase,
  }) : super(const HomeState());

  static const Map<int, String> _tabs = {
    0: 'trending',
    3: 'free',
    1: 'new',
    2: 'most_participated',
  };

  Future<void> getRecommendedTests() async {
    emit(
      state.copyWith(
        isRecommendedTestsLoading: true,
        recommendedTestsError: null,
      ),
    );

    try {
      final response = await getRecommendedTestsUseCase(
        tab: _tabs[state.filterIndex] ?? 'trending',
      );

      emit(
        state.copyWith(
          isRecommendedTestsLoading: false,
          recommendedTests: response.tests,
          recommendedTestsError: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isRecommendedTestsLoading: false,
          recommendedTestsError: e.toString(),
        ),
      );
    }
  }

  Future<void> getRecommendedInterests() async {
    emit(
      state.copyWith(
        isRecommendedInterestsLoading: true,
        recommendedInterestsError: null,
      ),
    );

    try {
      final response = await getRecommendedInterestsUseCase();

      emit(
        state.copyWith(
          isRecommendedInterestsLoading: false,
          recommendedInterests: response.interests,
          recommendedInterestsError: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isRecommendedInterestsLoading: false,
          recommendedInterestsError: e.toString(),
        ),
      );
    }
  }

  Future<void> getHomeData() async {
    await Future.wait([
      getRecommendedInterests(),
      getRecommendedTests(),
      getRecommendedUsers(),
    ]);
  }

  void changePage(int index) {
    emit(state.copyWith(pageIndex: index));
  }

  Future<void> changeFilter(int index) async {
    emit(
      state.copyWith(
        filterIndex: index,
        pageIndex: 0,
      ),
    );

    await getRecommendedTests();
  }
  Future<void> getRecommendedUsers() async {
  emit(
    state.copyWith(
      isRecommendedUsersLoading: true,
      recommendedUsersError: null,
    ),
  );

  try {
    final response = await getRecommendedUsersUseCase();

    emit(
      state.copyWith(
        isRecommendedUsersLoading: false,
        recommendedUsers: response.users,
        recommendedUsersError: null,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        isRecommendedUsersLoading: false,
        recommendedUsersError: e.toString(),
      ),
    );
  }
}
}