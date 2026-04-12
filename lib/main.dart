import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/config/app_router.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/settimgs/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/core/theme/settimgs/presentation/manager/theme_cubit/theme_state.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  //await CacheHelper.clearData();
  await initSl();
  AppRouter.init();

  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ThemeCubit>()..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.themeMode,
            themeAnimationDuration: const Duration(milliseconds: 900),
            themeAnimationCurve: Curves.easeInOutCubic,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
