import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_hint_play_mode.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/register_test_attempt_interaction_params.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/shimmers/flashcard_session_shimmer.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/FLASH_CARD/flashcard_bottom_action_section.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/FLASH_CARD/flashcard_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/FLASH_CARD/flashcard_progress_dots.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/FLASH_CARD/flashcard_session_info_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/FLASH_CARD/flashcard_summary_dialog.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/exit_test_play_mode_dialog.dart';

import '../../manager/test_play_mode/test_play_modes_state.dart';

class FlashcardSessionView extends StatefulWidget {
  final int testId;

  const FlashcardSessionView({super.key, required this.testId});

  @override
  State<FlashcardSessionView> createState() => _FlashcardSessionViewState();
}

class _FlashcardSessionViewState extends State<FlashcardSessionView> {
  double _cardSlideX = 0;
  double _cardOpacity = 1;

  int _cardColorOffset = 0;

  final List<Color> _flashcardColors = const [
    AppPalette.blueLight,
    AppPalette.violet,
    AppPalette.violetMedium,
  ];

  void _animateCardOut({required bool isKnown}) {
    setState(() {
      _cardSlideX = isKnown ? SizeConfig.w(1.2) : -SizeConfig.w(1.2);
      _cardOpacity = 0;
    });

    Future.delayed(const Duration(milliseconds: 260), () {
      if (!mounted) return;

      if (isKnown) {
        _onKnow();
      } else {
        _onDontKnow();
      }

      setState(() {
        _cardColorOffset = (_cardColorOffset + 1) % _flashcardColors.length;
        _cardSlideX = 0;
        _cardOpacity = 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final cubit = context.read<TestPlayModesCubit>();

      if (!cubit.state.hasPlayableContent) {
        await cubit.getTestPlayContent(testId: widget.testId);
      }

      cubit.startFlashcardSession();
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

  void _onFlipCard() {
    context.read<TestPlayModesCubit>().toggleFlashcard();
  }

  void _onKnow() {
    context.read<TestPlayModesCubit>().markCurrentFlashcardAsKnown();
  }

  void _onDontKnow() {
    context.read<TestPlayModesCubit>().markCurrentFlashcardAsUnknown();
  }

  void _showHint(String? hint) {
    final cleanHint = hint?.trim();

    if (cleanHint == null || cleanHint.isEmpty) return;

    showCustomerSnackBarHintPlayMode(
      context,
      title: 'تلميح',
      message: cleanHint,
    );
  }

  double _dragStartX = 0;

  void _onCardDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  void _onCardDragUpdate(DragUpdateDetails details) {
    setState(() {
      _cardSlideX += details.delta.dx;
      _cardOpacity = (1 - (_cardSlideX.abs() / SizeConfig.w(1.2))).clamp(
        0.25,
        1.0,
      );
    });
  }

  void _onCardDragEnd(DragEndDetails details) {
    final threshold = SizeConfig.w(0.22);

    if (_cardSlideX > threshold) {
      _animateCardOut(isKnown: true);
      return;
    }

    if (_cardSlideX < -threshold) {
      _animateCardOut(isKnown: false);
      return;
    }

    setState(() {
      _cardSlideX = 0;
      _cardOpacity = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<TestPlayModesCubit, TestPlayModesState>(
          listenWhen: (previous, current) =>
              !previous.isCompleted && current.isCompleted,
          listener: (context, state) {
            final testId = state.test?.testId;

            debugPrint("============ Flashcard complete listener ============");
            debugPrint("→ try register flashCard attempt interaction");
            debugPrint("→ testId: $testId");

            if (testId != null) {
              context
                  .read<TestPlayModesCubit>()
                  .registerTestAttemptInteractionSilently(
                    testId: testId,
                    mode: TestAttemptInteractionMode.flashCard,
                  );
            }
            debugPrint("=================================================");

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return FlashcardSummaryDialog(
                  state: state,
                  onPlayAgain: () {
                    debugPrint("play again ");
                    Navigator.of(dialogContext).pop();
                    context.read<TestPlayModesCubit>().startFlashcardSession();
                  },
                  onClose: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
          builder: (context, state) {
            final pageTitle = state.test?.title ?? 'البطاقات التعليمية';
            final question = state.currentFlashcardQuestion;
            final hint = question?.hintText?.trim();
            final hasHint = hint != null && hint.isNotEmpty;

            return Column(
              children: [
                TopPageHeader(
                  title: pageTitle,
                  onBack: _onBackTap,
                  icon: Icons.info_outline_rounded,
                  onIconTap: () => _showHint(hint),
                ),

                if (state.isContentLoading) ...[
                  const Expanded(child: FlashcardSessionShimmer()),
                ] else if (state.isContentFailure) ...[
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.08),
                        ),
                        child: CustomTextWidget(
                          state.errorMessage ?? 'حدث خطأ أثناء تحميل البطاقات',
                          color: AppPalette.red,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ),
                ] else if (question == null) ...[
                  const Expanded(child: SizedBox.shrink()),
                ] else ...[
                  SizedBox(height: SizeConfig.h(0.018)),

                  FlashcardSessionInfoHeader(state: state),

                  SizedBox(height: SizeConfig.h(0.012)),

                  FlashcardProgressDots(state: state),

                  SizedBox(height: SizeConfig.h(0.035)),

                  Expanded(
                    child: FlashcardCard(
                      question: question,
                      isRevealed: state.isFlashcardFlipped,
                      slideX: _cardSlideX,
                      opacity: _cardOpacity,
                      frontColor: _flashcardColors[_cardColorOffset],
                      secondColor:
                          _flashcardColors[(_cardColorOffset + 1) %
                              _flashcardColors.length],
                      thirdColor:
                          _flashcardColors[(_cardColorOffset + 2) %
                              _flashcardColors.length],
                      onTap: _onFlipCard,
                      hasHint: hasHint,
                      onHintTap: () => _showHint(hint),
                      onHorizontalDragStart: _onCardDragStart,
                      onHorizontalDragUpdate: _onCardDragUpdate,
                      onHorizontalDragEnd: _onCardDragEnd,
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.03)),

                  FlashcardBottomActionSection(
                    state: state,
                    onKnow: () => _animateCardOut(isKnown: true),
                    onDontKnow: () => _animateCardOut(isKnown: false),
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
