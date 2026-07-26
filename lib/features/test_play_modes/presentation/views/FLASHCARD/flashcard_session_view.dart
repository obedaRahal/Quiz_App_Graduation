import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_hint_play_mode.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
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

import '../../manager/test_play_mode/test_play_modes_state.dart';

class FlashcardSessionView extends StatefulWidget {
  final int testId;

  const FlashcardSessionView({super.key, required this.testId});

  @override
  State<FlashcardSessionView> createState() => _FlashcardSessionViewState();
}

class _FlashcardSessionViewState extends State<FlashcardSessionView>
    with SingleTickerProviderStateMixin {
  late final TestPlayModesCubit _cubit;
  late final AnimationController _edgeFlashController;
  late final Animation<double> _edgeFlashAnimation;

  double _cardSlideX = 0;
  double _cardOpacity = 1;
  int _cardColorOffset = 0;
  bool _isCardAnimating = false;
  Color _edgeFlashColor = Colors.transparent;

  final List<Color> _flashcardColors = const [
    AppPalette.blueLight,
    AppPalette.violet,
    AppPalette.violetMedium,
  ];

  @override
  void initState() {
    super.initState();

    _cubit = context.read<TestPlayModesCubit>();
    _edgeFlashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _edgeFlashAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 72,
      ),
    ]).animate(_edgeFlashController);

    Future.microtask(_loadSession);
  }

  @override
  void dispose() {
    _edgeFlashController.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    final loadedTestId = _cubit.state.test?.testId;

    if (!_cubit.state.hasPlayableContent || loadedTestId != widget.testId) {
      await _cubit.getTestPlayContent(testId: widget.testId);
    }

    if (!mounted ||
        _cubit.isClosed ||
        !_cubit.state.hasPlayableContent ||
        _cubit.state.test?.testId != widget.testId) {
      return;
    }

    _resetCardVisualState();
    _cubit.startFlashcardSession();
  }

  void _resetCardVisualState() {
    _edgeFlashController.reset();

    if (!mounted) return;

    setState(() {
      _cardSlideX = 0;
      _cardOpacity = 1;
      _cardColorOffset = 0;
      _isCardAnimating = false;
      _edgeFlashColor = Colors.transparent;
    });
  }

  void _animateCardOut({required bool isKnown}) {
    if (_isCardAnimating || _cubit.state.currentFlashcardQuestion == null) {
      return;
    }

    _isCardAnimating = true;
    _showAnswerEdgeFlash(isKnown: isKnown);
    unawaited(_cubit.stopVoiceAssistant());

    setState(() {
      _cardSlideX = isKnown ? SizeConfig.w(1.2) : -SizeConfig.w(1.2);
      _cardOpacity = 0;
    });

    Future.delayed(const Duration(milliseconds: 260), () {
      if (!mounted || _cubit.isClosed) return;

      if (isKnown) {
        _onKnow();
      } else {
        _onDontKnow();
      }

      setState(() {
        _cardColorOffset = (_cardColorOffset + 1) % _flashcardColors.length;
        _cardSlideX = 0;
        _cardOpacity = 1;
        _isCardAnimating = false;
      });
    });
  }

  void _showAnswerEdgeFlash({required bool isKnown}) {
    setState(() {
      _edgeFlashColor = isKnown ? AppPalette.green : AppPalette.red;
    });
    _edgeFlashController.forward(from: 0);
  }

  void _onBackTap() {
    final state = _cubit.state;

    if (state.isCompleted) {
      Navigator.pop(context);
      return;
    }

    showCustomConfirmationDialog(
      context: context,
      title: 'هل تريد مغادرة الاختبار حقاً ؟',
      message:
          'في حال غادرت الاختبار ستخسر تقدمك، ولن يتم تسجيل نتيجتك في قائمة سجل الاختبارات التي قمت بإجرائها',
      icon: Icons.exit_to_app_rounded,
      confirmText: 'مغادرة',
      cancelText: 'إلغاء',
      onConfirm: () {
        _cubit.resetSession();
        Navigator.pop(context);
      },
    );
  }

  void _onFlipCard() {
    if (_isCardAnimating) return;
    _cubit.toggleFlashcard();
  }

  void _onKnow() {
    _cubit.markCurrentFlashcardAsKnown();
  }

  void _onDontKnow() {
    _cubit.markCurrentFlashcardAsUnknown();
  }

  void _onSoundTap() {
    unawaited(_cubit.toggleVoiceAssistantForCurrentFlashcard());
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

  void _onCardDragUpdate(DragUpdateDetails details) {
    if (_isCardAnimating) return;

    setState(() {
      _cardSlideX += details.delta.dx;
      _cardOpacity = (1 - (_cardSlideX.abs() / SizeConfig.w(1.2))).clamp(
        0.25,
        1.0,
      );
    });
  }

  void _onCardDragEnd(DragEndDetails details) {
    if (_isCardAnimating) return;

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

  void _onSessionCompleted(BuildContext context, TestPlayModesState state) {
    final testId = state.test?.testId;

    debugPrint("============ Flashcard complete listener ============");
    debugPrint("→ try register flashCard attempt interaction");
    debugPrint("→ testId: $testId");

    if (testId != null) {
      _cubit.registerTestAttemptInteractionSilently(
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
            Navigator.of(dialogContext).pop();
            _resetCardVisualState();
            _cubit.startFlashcardSession();
          },
          onClose: () {
            Navigator.of(dialogContext).pop();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: MultiBlocListener(
              listeners: [
                BlocListener<TestPlayModesCubit, TestPlayModesState>(
                  listenWhen: (previous, current) =>
                      previous.voiceStatus != current.voiceStatus ||
                      previous.voiceErrorMessage != current.voiceErrorMessage,
                  listener: (context, state) {
                    if (!state.isVoiceFailure) return;

                    showValidationTopSnackBar(
                      context,
                      title: 'خطأ',
                      message:
                          state.voiceErrorMessage ??
                          'تعذر تشغيل المساعد الصوتي',
                      type: AppValidationSnackBarType.error,
                    );
                  },
                ),
                BlocListener<TestPlayModesCubit, TestPlayModesState>(
                  listenWhen: (previous, current) =>
                      !previous.isCompleted && current.isCompleted,
                  listener: _onSessionCompleted,
                ),
              ],
              child: BlocBuilder<TestPlayModesCubit, TestPlayModesState>(
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
                        icon: state.isVoiceSpeaking
                            ? Icons.stop_circle_outlined
                            : Icons.volume_up_outlined,
                        onIconTap: _onSoundTap,
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextWidget(
                                    state.errorMessage ??
                                        'حدث خطأ أثناء تحميل البطاقات',
                                    color: AppPalette.red,
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(height: SizeConfig.h(0.018)),
                                  OutlinedButton.icon(
                                    onPressed: _loadSession,
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] else if (question == null) ...[
                        const Expanded(
                          child: Center(
                            child: CustomTextWidget(
                              'لا توجد بطاقات تعليمية متاحة',
                              color: AppPalette.greyMedium,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
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
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _edgeFlashAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FlashcardEdgeFlashPainter(
                    color: _edgeFlashColor,
                    intensity: _edgeFlashAnimation.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashcardEdgeFlashPainter extends CustomPainter {
  final Color color;
  final double intensity;

  const _FlashcardEdgeFlashPainter({
    required this.color,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0 || color == Colors.transparent) return;

    final strokeWidth = 10 + (10 * intensity);
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final paint = Paint()
      ..color = color.withValues(alpha: 0.85 * intensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 7 + (9 * intensity));

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(18)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FlashcardEdgeFlashPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.intensity != intensity;
  }
}
