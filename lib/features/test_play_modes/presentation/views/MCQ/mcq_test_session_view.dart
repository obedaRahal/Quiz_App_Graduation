import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_hint_play_mode.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/shimmers/mcq_test_session_shimmer.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_result_summary_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/MCQ/mcq_bottom_action_section.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/MCQ/mcq_question_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/MCQ/mcq_session_info_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/exit_test_play_mode_dialog.dart';

class McqTestSessionView extends StatefulWidget {
  final int testId;
  const McqTestSessionView({super.key, required this.testId});

  @override
  State<McqTestSessionView> createState() => _McqTestSessionViewState();
}

class _McqTestSessionViewState extends State<McqTestSessionView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      //context.read<TestPlayModesCubit>().loadMockTestContent();
      context.read<TestPlayModesCubit>().getTestPlayContent(
        testId: widget.testId,
      );
    });
  }

  void _onBackTap() {
    final state = context.read<TestPlayModesCubit>().state;

    if (state.isCompleted) {
      Navigator.pop(context);
      return;
    }

    // showExitTestPlayModeDialog(
    //   context: context,
    //   onExitConfirmed: () {
    //     context.read<TestPlayModesCubit>().resetSession();
    //     Navigator.pop(context);
    //   },
    // );
    showCustomConfirmationDialog(
      context: context,
      title: 'هل تريد مغادرة الاختبار حقاً ؟',
      message:
          'في حال غادرت الاختبار ستخسر تقدمك، ولن يتم تسجيل نتيجتك في قائمة سجل الاختبارات التي قمت بإجرائها',
      icon: Icons.exit_to_app_rounded,
      confirmText: 'مغادرة',
      cancelText: 'إلغاء',
      onConfirm: () {
        // منطق المغادرة
        context.read<TestPlayModesCubit>().resetSession();
        Navigator.pop(context);
      },
    );
  }

  void _onSoundTap() {
    debugPrint('sound');
    context.read<TestPlayModesCubit>().toggleVoiceAssistantForCurrentQuestion();
  }

  void _onSelectOption(int optionId) {
    context.read<TestPlayModesCubit>().selectMcqOption(optionId: optionId);
  }

  void _onCheckAnswer() {
    context.read<TestPlayModesCubit>().checkCurrentMcqAnswer();
  }

  void _onNextQuestion() {
    context.read<TestPlayModesCubit>().goToNextMcqQuestion();
  }

  void _onShowHint(String? hint) {
    final cleanHint = hint?.trim();

    if (cleanHint == null || cleanHint.isEmpty) return;

    showCustomerSnackBarHintPlayMode(
      context,
      title: 'السبب',
      message: cleanHint,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<TestPlayModesCubit, TestPlayModesState>(
          listenWhen: (previous, current) =>
              previous.voiceStatus != current.voiceStatus ||
              previous.voiceErrorMessage != current.voiceErrorMessage,
          listener: (context, state) {
            if (state.isVoiceFailure) {
              showValidationTopSnackBar(
                context,
                title: 'خطأ',
                message: state.voiceErrorMessage ?? 'تعذر تشغيل المساعد الصوتي',
                type: AppValidationSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            final pageTitle = state.test?.title ?? '';

            return Column(
              children: [
                if (!state.isCompleted)
                  TopPageHeader(
                    title: pageTitle,
                    onBack: _onBackTap,
                    icon: state.isVoiceSpeaking
                        ? Icons.stop_circle_outlined
                        : Icons.volume_up_outlined,
                    onIconTap: _onSoundTap,
                  ),

                if (state.isContentLoading) ...[
                  const Expanded(child: McqTestSessionShimmer()),
                ] else if (state.isContentFailure) ...[
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.08),
                        ),
                        child: CustomTextWidget(
                          state.errorMessage ?? 'حدث خطأ أثناء تحميل الاختبار',
                          color: AppPalette.red,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          fontSize: SizeConfig.text(0.035),
                        ),
                      ),
                    ),
                  ),
                ] else if (state.isCompleted) ...[
                  const Expanded(child: McqResultSummaryView()),
                ] else ...[
                  _McqLoadedBody(
                    state: state,
                    onSelectOption: _onSelectOption,
                    onCheckAnswer: _onCheckAnswer,
                    onNextQuestion: _onNextQuestion,
                    onShowHint: _onShowHint,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _McqLoadedBody extends StatelessWidget {
  final TestPlayModesState state;
  final ValueChanged<int> onSelectOption;
  final VoidCallback onCheckAnswer;
  final VoidCallback onNextQuestion;
  final ValueChanged<String?> onShowHint;

  const _McqLoadedBody({
    required this.state,
    required this.onSelectOption,
    required this.onCheckAnswer,
    required this.onNextQuestion,
    required this.onShowHint,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final question = state.currentQuestion;

    if (question == null) {
      return const Expanded(child: SizedBox.shrink());
    }

    return Expanded(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.h(0.018)),

          McqSessionInfoHeader(state: state),

          McqProgressBar(value: state.progressValue),

          SizedBox(height: SizeConfig.h(0.025)),

          Expanded(
            child: CustomBackgroundWithChild(
              width: double.infinity,
              backgroundColor: AppPalette.black,
              alignment: Alignment.topCenter,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: isDark
                    ? [
                        const Color.fromARGB(255, 29, 58, 121),
                        const Color.fromARGB(255, 62, 123, 221),
                      ]
                    : [AppPalette.blueDark, AppPalette.blueLight],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.h(0.025),
                  vertical: SizeConfig.h(0.025),
                ),
                child: McqQuestionCard(
                  state: state,
                  onOptionTap: onSelectOption,
                ),
              ),
            ),
          ),

          CustomBackgroundWithChild(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(0.03)),
            width: double.infinity,
            backgroundColor: isDark
                ? const Color.fromARGB(255, 29, 58, 121)
                : AppPalette.blueDark,
            child: CustomBackgroundWithChild(
              width: double.infinity,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              backgroundColor: appColors.whiteToblack,
              child: McqBottomActionSection(
                state: state,
                onCheckAnswer: onCheckAnswer,
                onNextQuestion: onNextQuestion,
                onShowHint: onShowHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
