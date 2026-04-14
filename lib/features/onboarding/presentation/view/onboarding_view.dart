import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/current_university_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/education_level_step.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/widgets/steps/heard_about_step.dart';
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

        return OnboardingScaffold(
          currentStep: state.currentStepIndex,
          totalSteps: state.visibleSteps.length,
          title: _getStepTitle(currentStep),
          description: _getStepDescription(currentStep),
          isNextEnabled: state.canGoNext,
          isSubmitting: state.isSubmitting,
          onNext: () {
            debugPrint("im at ${_getStepTitle(currentStep)}");
            debugPrint("and  ${state.heardAbout}");
            context.read<OnboardingCubit>().nextStep();
          },
          // onBack: () {
          //   final cubit = context.read<OnboardingCubit>();

          //   if (state.isFirstStep) {
          //     //context.pop();
          //     return;
          //   }

          //   cubit.previousStep();
          // },
          onBack: () {
            final cubit = context.read<OnboardingCubit>();

            if (state.isFirstStep) {
              context.goNamed(AppRouterName.welcome);
              return;
            }

            cubit.previousStep();

            // أول خطوة: لا نخرج لأن الـ onboarding إجباري
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
        return 'أهلًا بك معنا';
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
        return 'تم تجهيز معلوماتك الأساسية بنجاح، ونحن جاهزون للانطلاق معك.';
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
        return _StepPlaceholder(text: 'محتوى خطوة: الاهتمامات العلمية');

      case OnboardingStepType.graduatedUniversity:
        return _StepPlaceholder(text: 'محتوى خطوة: جامعة التخرج');

      case OnboardingStepType.done:
        return _StepPlaceholder(text: 'محتوى خطوة: الواجهة الختامية');
    }
  }
}

class _StepPlaceholder extends StatelessWidget {
  final String text;

  const _StepPlaceholder({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34),
        child: CustomTextWidget(text, textAlign: TextAlign.center),
      ),
    );
  }
}
