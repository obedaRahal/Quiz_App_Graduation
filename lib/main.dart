import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/config/app_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/deep_link/deep_link_service.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';
import 'package:quiz_app_grad/core/services/notification/push_notification_service.dart';
import 'package:quiz_app_grad/features/study_alarm/services/study_alarm_ringing_service.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_state.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiz_app_grad/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Alarm.init();

  await TokenStorage.clear();

  await CacheHelper.init();
  await initSl();
  AppRouter.init();
  await initializeDateFormatting('ar');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await LocalNotificationService.init();
  await PushNotificationService.init();

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
      if (sl.isRegistered<StudyAlarmRingingService>()) {
        sl<StudyAlarmRingingService>().init(
          onAlarmRinging: (alarmSettings) async {
            await AppRouter.router.pushNamed(
              AppRouterName.studyAlarmRinging,
              extra: alarmSettings,
            );
          },
        );
      }

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
  void dispose() {
    if (sl.isRegistered<StudyAlarmRingingService>()) {
      unawaited(sl<StudyAlarmRingingService>().dispose());
    }
    super.dispose();
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
