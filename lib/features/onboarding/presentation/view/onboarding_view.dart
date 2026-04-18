import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/done_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/education_level_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/graduated_university_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/heard_about_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/interests_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/school_stage_step.dart';
import '../manager/onboarding_step_type.dart';
import '../widgets/onboarding_scaffold.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final currentStep = state.currentStep;
        final isDoneStep = currentStep == OnboardingStepType.done;

        return OnboardingScaffold(
          currentStep: state.currentStepIndex + 1,
          totalSteps: state.visibleSteps.length,
          title: !isDoneStep ? _getStepTitle(currentStep) : null,
          description: isDoneStep ? null : _getStepDescription(currentStep),
          nextButtonText: isDoneStep ? 'العودة لتسجيل الدخول' : 'التالي',
          isNextEnabled: state.canGoNext,
          isSubmitting: state.isSubmitting,
          onNext: () {
            if (isDoneStep) {
              sl<AuthSession>().markUnauthenticated();
              context.goNamed(AppRouterName.welcome);
              return;
            }

            context.read<OnboardingCubit>().nextStep();
          },
          onBack: () {
            final cubit = context.read<OnboardingCubit>();
                sl<AuthSession>().markUnauthenticated();
            if (state.isFirstStep) {
              context.goNamed(AppRouterName.welcome);
              return;
            }

            cubit.previousStep();
          },
          child: _buildStepContent(context, state),
        );
      },
    );
  }

  String _getStepTitle(OnboardingStepType step) {
    switch (step) {
      case OnboardingStepType.heardAbout:
        return "صديقي المستخدم كيف سمعت عن التطبيق الخاص بنا ؟";

      case OnboardingStepType.educationLevel:
        return 'الى أي مستوى دراسي وصلت في الوقت الحالي ؟';

      case OnboardingStepType.currentUniversity:
        return 'في أي جامعة تدرس في الفترة الحالية ؟';

      case OnboardingStepType.schoolStage:
        return 'في أي مرحلة دراسية أنت تتواجد الآن ؟';

      case OnboardingStepType.interests:
        return 'ما هي اهتماماتك العلمية حاليًا؟';

      case OnboardingStepType.graduatedUniversity:
        return 'من أي جامعة تخرجت؟';

      case OnboardingStepType.done:
        return '';
    }
  }

  String _getStepDescription(OnboardingStepType step) {
    switch (step) {
      case OnboardingStepType.heardAbout:
        return "يساعدنا هذا السؤال على معرفة مصدر شهرة التطبيق ، يمكنك ان تختار خيار واحد فقط";

      case OnboardingStepType.educationLevel:
        return 'يساعدنا هذا السؤال على معرفة مستواك العلمي ، يمكنك اختيار خيار واحد فقط';

      case OnboardingStepType.currentUniversity:
        return 'يساعدنا هذا السؤال على معرفة مستواك العلمي ، يمكنك اختيار خيار واحد فقط';

      case OnboardingStepType.schoolStage:
        return 'يساعدنا هذا السؤال على معرفة التقدم العلمي الخاص بك ، يمكنك اختيار خيار واحد فقط';

      case OnboardingStepType.interests:
        return 'يمكنك اختيار من 1 إلى 5 اهتمامات علمية كحد أقصى.';

      case OnboardingStepType.graduatedUniversity:
        return 'اكتب اسم الجامعة التي تخرجت منها.';

      case OnboardingStepType.done:
        return '';
    }
  }

  Widget _buildStepContent(BuildContext context, OnboardingState state) {
    switch (state.currentStep) {
      case OnboardingStepType.heardAbout:
        return const HeardAboutStep();

      case OnboardingStepType.educationLevel:
        return const EducationLevelStep();

      case OnboardingStepType.currentUniversity:
        return const CurrentUniversityStep();

      case OnboardingStepType.schoolStage:
        return const SchoolStageStep();

      case OnboardingStepType.interests:
        final cubit = context.read<OnboardingCubit>();
        if (state.interestGroups.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cubit.loadMockInterests();
          });
        }
        return const InterestsStep();

      // case OnboardingStepType.interests:
      //   return const InterestsStep();

      case OnboardingStepType.graduatedUniversity:
        return const GraduatedUniversityStep();

      case OnboardingStepType.done:
        return const OnboardingDoneStep();
    }
  }
}
