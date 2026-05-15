import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';

void safeBackToHome(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.goNamed(AppRouterName.mainLayout);
  }
}
