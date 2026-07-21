import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/config/app_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/deep_link/deep_link_service.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_state.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await TokenStorage.clear();

  await CacheHelper.init();
  await initSl();
  AppRouter.init();
  await initializeDateFormatting('ar');

  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<DeepLinkService>().init(
        onTestSlugReceived: (slug) {
          final path = AppRouterPath.sharedTestRedirectPath(slug);

          debugPrint("============ App Deep Link Navigation ============");
          debugPrint("→ slug: $slug");
          debugPrint("→ path: $path");
          debugPrint("=================================================");

          AppRouter.router.go(path);

          debugPrint("✓ router.go called");
        },
      );
    });
  }

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
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
