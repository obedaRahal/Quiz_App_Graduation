import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_view_body.dart';

class SoldTestsView extends StatelessWidget {
  const SoldTestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: SoldTestsViewBody()));
  }
}
