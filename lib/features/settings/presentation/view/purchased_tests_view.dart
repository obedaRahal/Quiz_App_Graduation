import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/purchased_tests/purchased_tests_view_body.dart';

class PurchasedTestsView extends StatelessWidget {
  const PurchasedTestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: PurchasedTestsViewBody()));
  }
}
