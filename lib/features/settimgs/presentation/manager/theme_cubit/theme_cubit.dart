import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/settimgs/domain/use_cases/get_theme_mode_use_case.dart';
import 'package:quiz_app_grad/features/settimgs/domain/use_cases/set_theme_mode_use_case.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SetThemeModeUseCase setThemeModeUseCase;

  ThemeCubit({
    required this.getThemeModeUseCase,
    required this.setThemeModeUseCase,
  }) : super(const ThemeState()) {
    debugPrint("============ ThemeCubit INIT ============");
  }

  void loadTheme() {
    debugPrint("============ ThemeCubit.loadTheme ============");

    final mode = getThemeModeUseCase();
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> changeTheme(ThemeMode mode) async {
            debugPrint("============ ThemeCubit.changeTheme ============");

    await setThemeModeUseCase(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> toggleTheme() async {
            debugPrint("============ ThemeCubit.toggleTheme ============");

    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    await changeTheme(newMode);
  }
}
