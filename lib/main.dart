import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/config/app_router.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/features/settimgs/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/settimgs/presentation/manager/theme_cubit/theme_state.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  //await CacheHelper.clearData();

  // debugPrint("============ MAIN START ============");
  // debugPrint(
  //   "before clear token => ${(await TokenStorage.getAccessToken())?.length ?? 0}",
  // );
  // debugPrint(
  //   "before clear expiry => ${await TokenStorage.getAccessTokenExpiry()}",
  // );

  // await TokenStorage.clear();

  // debugPrint(
  //   "after clear token => ${(await TokenStorage.getAccessToken())?.length ?? 0}",
  // );
  // debugPrint(
  //   "after clear expiry => ${await TokenStorage.getAccessTokenExpiry()}",
  // );

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
            //themeAnimationDuration: const Duration(milliseconds: 900),
            //themeAnimationCurve: Curves.easeInOutCubic,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
