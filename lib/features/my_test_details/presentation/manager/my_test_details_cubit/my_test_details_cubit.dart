import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';

class MyTestDetailsCubit extends Cubit<MyTestDetailsState> {
  MyTestDetailsCubit() : super(const MyTestDetailsState());

  void changeSelectedTab(MyTestDetailsTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void loadMockTestDetails() {
    emit(state.copyWith(testDetails: TestDetailsMockData.mockTestDetails));
  }

  void selectSampleAnswer({required int questionId, required int optionId}) {
    debugPrint(
      "============ DetailsOfTestCubit.selectSampleAnswer ============",
    );
    debugPrint("→ questionId: $questionId");
    debugPrint("→ optionId: $optionId");

    if (state.selectedSampleAnswers.containsKey(questionId)) {
      debugPrint("✗ answer already selected for this question");
      debugPrint("=================================================");
      return;
    }

    final updatedAnswers = Map<int, int>.from(state.selectedSampleAnswers);
    updatedAnswers[questionId] = optionId;

    emit(state.copyWith(selectedSampleAnswers: updatedAnswers));

    debugPrint("✓ sample answer selected");
    debugPrint("=================================================");
  }

  void changeSelectedRatingFilter(String rating) {
  emit(state.copyWith(selectedRatingFilter: rating));
}
}
