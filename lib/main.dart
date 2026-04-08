import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/config/app_router.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

void main() async {
  runApp(const QuizApp());
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  await CacheHelper.clearData();
  await initSl();
    AppRouter.init();
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(scaffoldBackgroundColor: AppColor.white),
    routerConfig: AppRouter.router,
    
    );
  
  
  }
}
