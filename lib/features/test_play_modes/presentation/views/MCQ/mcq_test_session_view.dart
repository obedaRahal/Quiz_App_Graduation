import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_hint_play_mode.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_result_summary_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/MCQ/mcq_bottom_action_section.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/MCQ/mcq_question_card.dart';

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
    Navigator.pop(context);
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
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            if (state.isContentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isContentFailure) {
              return Center(
                child: CustomTextWidget(
                  state.errorMessage ?? 'حدث خطأ أثناء تحميل الاختبار',
                  color: AppPalette.red,
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (state.isCompleted) {
              return const McqResultSummaryView();
            }

            final question = state.currentQuestion;

            if (question == null) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                TopPageHeader(
                  title: 'جلسة امتحانية أولى',
                  onBack: _onBackTap,
                  icon: state.isVoiceSpeaking
                      ? Icons.stop_circle_outlined
                      : Icons.volume_up_outlined,
                  onIconTap: _onSoundTap,
                ),
                CustomButtonWidget(
                  onTap: () {
                    debugPrint("change mode ");
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  child: ThemedAppImage(
                    darkPath: AppImage.logoDark,
                    lightPath: AppImage.logoLight,
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                McqSessionInfoHeader(state: state),

                _McqProgressBar(value: state.progressValue),

                SizedBox(height: SizeConfig.h(0.025)),

                Expanded(
                  child: CustomBackgroundWithChild(
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
                        onOptionTap: _onSelectOption,
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
                      onCheckAnswer: _onCheckAnswer,
                      onNextQuestion: _onNextQuestion,
                      onShowHint: _onShowHint,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class McqSessionInfoHeader extends StatelessWidget {
  final TestPlayModesState state;

  const McqSessionInfoHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Row(
        children: [
          _TimePill(seconds: state.remainingSeconds),
          const Spacer(),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${state.totalQuestions}',
                  style: TextStyle(
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.05),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
                TextSpan(
                  text: '\\',
                  style: TextStyle(
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.06),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
                TextSpan(
                  text: '${state.currentQuestionNumber}',
                  style: TextStyle(
                    color: appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.07),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final int seconds;

  const _TimePill({required this.seconds});

  String get formattedTime {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              "مؤقت",
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.025),
            ),
            CustomTextWidget(
              formattedTime,
              color: appColors.blackToGrey2Dark,
              fontSize: SizeConfig.text(0.032),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        SizedBox(width: SizeConfig.w(0.015)),

        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderRadius: BorderRadius.circular(30),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.01),
            vertical: SizeConfig.w(0.01),
          ),
          child: Icon(
            Icons.timer_outlined,
            size: SizeConfig.h(0.03),
            color: AppPalette.primary,
          ),
        ),
      ],
    );
  }
}

class _McqProgressBar extends StatelessWidget {
  final double value;

  const _McqProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.centerRight,
          height: SizeConfig.h(0.015),
          width: double.infinity,
          color: appColors.greyToGreyMediumDark,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value.clamp(0, 1)),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                builder: (context, animatedValue, child) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      width: constraints.maxWidth * animatedValue,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color(0xFF4A90E2),
                            Color(0xFF6A5AE0),
                            Color(0xFF8E6CFF),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                            color: Colors.blue.withOpacity(0.25),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
