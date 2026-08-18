import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/app_keyboard_dismiss_scope.dart';
import 'package:quiz_app_grad/core/config/app_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/services/deep_link/deep_link_service.dart';
import 'package:quiz_app_grad/core/services/payment/payment_attempt_storage.dart';
import 'package:quiz_app_grad/core/services/notification/local_votification_service.dart';
import 'package:quiz_app_grad/core/services/notification/notification_tap_service.dart';
import 'package:quiz_app_grad/core/services/notification/push_notification_service.dart';
import 'package:quiz_app_grad/core/utils/app_logger.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/study_alarm/services/study_alarm_ringing_service.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_state.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiz_app_grad/firebase_options.dart';

void main() async {
  AppLogger.configure();
  WidgetsFlutterBinding.ensureInitialized();


  await CacheHelper.init();
  await initSl();
  AppRouter.init();
  await initializeDateFormatting('ar');

  final optionalServices = await Future.wait<bool>([
    _initializeOptionalService('Alarm', () async {
      await Alarm.init();
    }),
    _initializeOptionalService('Firebase', () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }),
    _initializeOptionalService(
      'Local notifications',
      LocalNotificationService.init,
    ),
  ]);

  final alarmReady = optionalServices[0];
  final firebaseReady = optionalServices[1];

  if (firebaseReady) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  runApp(QuizApp(alarmReady: alarmReady));

  if (firebaseReady) {
    unawaited(
      _initializeOptionalService(
        'Push notifications',
        PushNotificationService.init,
      ),
    );
  }
}

Future<bool> _initializeOptionalService(
  String name,
  Future<void> Function() initialize,
) async {
  try {
    await initialize().timeout(const Duration(seconds: 20));
    debugPrint('✓ optional service initialized: $name');
    return true;
  } catch (error, stackTrace) {
    debugPrint('✗ optional service failed: $name (${error.runtimeType})');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}

class QuizApp extends StatefulWidget {
  final bool alarmReady;

  const QuizApp({super.key, this.alarmReady = false});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  StreamSubscription<void>? _notificationTapSubscription;
  AuthSession? _authSession;
  bool _notificationNavigationScheduled = false;

  @override
  void initState() {
    super.initState();

    _authSession = sl<AuthSession>()..addListener(_onAuthSessionChanged);
    _notificationTapSubscription = NotificationTapService.taps.listen((_) {
      _scheduleNotificationNavigation();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.alarmReady && sl.isRegistered<StudyAlarmRingingService>()) {
        sl<StudyAlarmRingingService>().init(
          onAlarmRinging: (alarmSettings) async {
            await AppRouter.router.pushNamed(
              AppRouterName.studyAlarmRinging,
              extra: alarmSettings,
            );
          },
        );
      }

      unawaited(_initializeDeepLinks());
      _scheduleNotificationNavigation();
    });
  }

  Future<void> _initializeDeepLinks() async {
    try {
      await sl<DeepLinkService>().init(
        onTestSlugReceived: (slug) {
          AppRouter.router.go(AppRouterPath.sharedTestRedirectPath(slug));
        },
        onLibrarySlugReceived: (slug) {
          AppRouter.router.go(AppRouterPath.sharedContentRedirectPath(slug));
        },
        onProfileSlugReceived: (slug) {
          AppRouter.router.go(AppRouterPath.sharedProfileRedirectPath(slug));
        },
        onPaymentReturnReceived: ({required result, paymentAttemptId}) {
          final paymentStorage = sl<PaymentAttemptStorage>();
          final storedAttemptId = paymentStorage.attemptId;
          final attemptId = paymentAttemptId ?? storedAttemptId;
          final testId = paymentStorage.testId;

          if (attemptId == null || attemptId <= 0 || testId == null || testId <= 0) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            AppRouter.router.go(
              AppRouterPath.detailsOfTest,
              extra: DetailsOfTestRouteArgs(
                testId: testId,
                paymentAttemptId: attemptId,
                paymentWasCancelled: result == 'cancel',
              ),
            );
          });
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ DeepLinkService initialization failed');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _onAuthSessionChanged() {
    _scheduleNotificationNavigation();
  }

  void _scheduleNotificationNavigation() {
    if (!mounted ||
        _notificationNavigationScheduled ||
        !NotificationTapService.hasPendingTap ||
        _authSession?.isAuthenticated != true) {
      return;
    }

    _notificationNavigationScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationNavigationScheduled = false;

      if (!mounted ||
          _authSession?.isAuthenticated != true ||
          !NotificationTapService.consumePendingTap()) {
        return;
      }

      final currentPath =
          AppRouter.router.routeInformationProvider.value.uri.path;

      if (currentPath == AppRouterPath.notifications) {
        return;
      }

      unawaited(AppRouter.router.pushNamed(AppRouterName.notifications));
    });
  }

  @override
  void dispose() {
    _authSession?.removeListener(_onAuthSessionChanged);
    unawaited(_notificationTapSubscription?.cancel() ?? Future<void>.value());

    if (sl.isRegistered<StudyAlarmRingingService>()) {
      unawaited(sl<StudyAlarmRingingService>().dispose());
    }
    if (sl.isRegistered<DeepLinkService>()) {
      unawaited(sl<DeepLinkService>().dispose());
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
            builder: (context, child) {
              return AppKeyboardDismissScope(
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
