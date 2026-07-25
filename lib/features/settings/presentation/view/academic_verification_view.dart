import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/academic_verification/academic_verification_view_body.dart';

class AcademicVerificationView extends StatelessWidget {
  const AcademicVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: AcademicVerificationViewBody(),
      ),
    );
  }
}