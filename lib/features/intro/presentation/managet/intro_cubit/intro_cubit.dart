import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';

import 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit() : super(const IntroState()) {
    debugPrint("============ IntroCubit INIT ============");
  }

  void pageChanged(int index) {
    emit(state.copyWith(currentPage: index, errorMessage: null));
  }

  Future<void> finishIntro() async {
    debugPrint("/////////  finishIntro  //////");
    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      debugPrint(
        "value of hasSeenIntroKey at cache is : ${CacheHelper.getData(key: CacheHelper.hasSeenIntroKey)}",
      );
      await CacheHelper.saveData(key: CacheHelper.hasSeenIntroKey, value: true);

      emit(state.copyWith(isSaving: false, isFinished: true));
      debugPrint(
        "and value of hasSeenIntroKey at cache become : ${CacheHelper.getData(key: CacheHelper.hasSeenIntroKey)}",
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          isFinished: false,
          errorMessage: 'حدث خطأ أثناء حفظ حالة الواجهة التعريفية',
        ),
      );
    }
  }
}
