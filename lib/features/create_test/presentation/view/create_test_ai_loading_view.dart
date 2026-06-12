import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_cubit.dart' show CreateTestCubit;
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_state.dart';

class CreateTestAiLoadingView extends StatelessWidget {
  final CreateTestInitialArgs args;

  const CreateTestAiLoadingView({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateTestCubit>(
      create: (_) => sl<CreateTestCubit>()
        ..startAiQuestionGenerationAndPoll(args),
      child: BlocListener<CreateTestCubit, CreateTestState>(
        listenWhen: (previous, current) {
          return previous.isAiQuestionGenerationCompleted !=
                  current.isAiQuestionGenerationCompleted ||
              previous.aiQuestionGenerationError !=
                  current.aiQuestionGenerationError;
        },
        listener: (context, state) {
          final error = state.aiQuestionGenerationError;

          if (error != null && error.trim().isNotEmpty) {
            ScaffoldMessenger.of(context).clearSnackBars();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppPalette.red,
                elevation: 0,
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: CustomTextWidget(
                    error,
                    fontSize: SizeConfig.text(0.031),
                    fontWeight: FontWeight.w800,
                    color: AppPalette.white,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                  ),
                ),
              ),
            );

            context.read<CreateTestCubit>().clearAiQuestionGenerationResult();

            if (context.canPop()) {
              context.pop();
            }

            return;
          }

          if (state.isAiQuestionGenerationCompleted &&
              state.aiGeneratedQuestions.isNotEmpty) {
            context.goNamed(
              AppRouterName.createTestPage,
              extra: args.copyWith(
                generatedQuestions: state.aiGeneratedQuestions,
                aiProvider: state.aiProvider,
              ),
            );
          }
        },
        child: _CreateTestAiLoadingContent(args: args),
      ),
    );
  }
}
class _CreateTestAiLoadingContent extends StatelessWidget {
  final CreateTestInitialArgs args;

  const _CreateTestAiLoadingContent({
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? AppPalette.black : AppPalette.white,
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.055)),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.h(0.030)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: SizeConfig.w(0.095),
                      height: SizeConfig.w(0.095),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppPalette.fieldColorNDark
                            : const Color(0xFFF6F6F6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppPalette.borderFieldColorNDark
                              : AppPalette.borderFieldColorNLight,
                        ),
                      ),
                      child: Icon(
                        Icons.hourglass_top_rounded,
                        size: SizeConfig.text(0.044),
                        color: appColors.primaryToPrimaryDark,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const _AiLoadingAnimation(),

                  SizedBox(height: SizeConfig.h(0.045)),

                  CustomTextWidget(
                    'يتم توليد الأسئلة الآن',
                    fontSize: SizeConfig.text(0.050),
                    fontWeight: FontWeight.w900,
                    color: isDark
                        ? AppPalette.textWhiteINDark
                        : AppPalette.textColorInHome,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: SizeConfig.h(0.010)),

                  CustomTextWidget(
                    _subtitle,
                    fontSize: SizeConfig.text(0.032),
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),

                  SizedBox(height: SizeConfig.h(0.030)),

                  _GenerationInfoCard(args: args),

                  SizedBox(height: SizeConfig.h(0.035)),

                  _AnimatedProgressText(
                    isDark: isDark,
                  ),

                  const Spacer(),

                  Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(0.030)),
                    child: CustomTextWidget(
                      'يرجى عدم إغلاق الصفحة حتى انتهاء عملية التوليد',
                      fontSize: SizeConfig.text(0.028),
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    if (args.isAiImages) {
      return 'نقوم بتحليل الصور المرفقة واستخراج الأسئلة المناسبة منها باستخدام الذكاء الاصطناعي.';
    }

    return 'نقوم بتحليل الملف المرفق واستخراج الأسئلة المناسبة منه باستخدام الذكاء الاصطناعي.';
  }
}
class _AiLoadingAnimation extends StatefulWidget {
  const _AiLoadingAnimation();

  @override
  State<_AiLoadingAnimation> createState() => _AiLoadingAnimationState();
}

class _AiLoadingAnimationState extends State<_AiLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return SizedBox(
      width: SizeConfig.w(0.62),
      height: SizeConfig.w(0.62),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = _controller.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: value * math.pi * 2,
                child: CustomPaint(
                  size: Size(
                    SizeConfig.w(0.58),
                    SizeConfig.w(0.58),
                  ),
                  painter: _OrbitPainter(
                    color: appColors.primaryToPrimaryDark.withOpacity(0.22),
                  ),
                ),
              ),

              ...List.generate(4, (index) {
                final angle = (value * math.pi * 2) +
                    (index * math.pi / 2);

                final radius = SizeConfig.w(0.245);
                final dx = math.cos(angle) * radius;
                final dy = math.sin(angle) * radius;

                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Container(
                    width: SizeConfig.w(index.isEven ? 0.030 : 0.022),
                    height: SizeConfig.w(index.isEven ? 0.030 : 0.022),
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? appColors.primaryToPrimaryDark
                          : AppPalette.purple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: appColors.primaryToPrimaryDark.withOpacity(
                            isDark ? 0.20 : 0.28,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              Transform.scale(
                scale: 1 + (math.sin(value * math.pi * 2) * 0.035),
                child: Container(
                  width: SizeConfig.w(0.34),
                  height: SizeConfig.w(0.34),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.fieldColorNDark
                        : AppPalette.primarySoft,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : appColors.primaryToPrimaryDark.withOpacity(0.25),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: SizeConfig.w(0.21),
                      height: SizeConfig.w(0.21),
                      decoration: BoxDecoration(
                        color: isDark ? AppPalette.black : AppPalette.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? AppPalette.borderFieldColorNDark
                              : AppPalette.borderFieldColorNLight,
                        ),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: SizeConfig.text(0.074),
                        color: appColors.primaryToPrimaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final Color color;

  const _OrbitPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width * 0.42, paint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.36),
      -math.pi / 2,
      math.pi * 1.2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _GenerationInfoCard extends StatelessWidget {
  final CreateTestInitialArgs args;

  const _GenerationInfoCard({
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.040),
        vertical: SizeConfig.h(0.016),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.14 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            title: 'طريقة التوليد',
            value: args.isAiImages ? 'صور' : 'ملف',
          ),
          SizedBox(height: SizeConfig.h(0.010)),
          _InfoRow(
            title: 'عدد الأسئلة',
            value: '${args.aiQuestionCount ?? 10}',
          ),
          SizedBox(height: SizeConfig.h(0.010)),
          _InfoRow(
            title: 'المستوى',
            value: args.aiLevel ?? 'سهل',
          ),
          SizedBox(height: SizeConfig.h(0.010)),
          _InfoRow(
            title: 'اللغة',
            value: args.aiLanguage ?? 'عربية',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        CustomTextWidget(
          title,
          fontSize: SizeConfig.text(0.030),
          fontWeight: FontWeight.w700,
          color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
          textAlign: TextAlign.right,
        ),

        const Spacer(),

        CustomTextWidget(
          value,
          fontSize: SizeConfig.text(0.031),
          fontWeight: FontWeight.w900,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class _AnimatedProgressText extends StatefulWidget {
  final bool isDark;

  const _AnimatedProgressText({
    required this.isDark,
  });

  @override
  State<_AnimatedProgressText> createState() => _AnimatedProgressTextState();
}

class _AnimatedProgressTextState extends State<_AnimatedProgressText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<String> messages = const [
    'جاري قراءة المحتوى',
    'جاري تحليل المعلومات',
    'جاري بناء الأسئلة',
    'جاري تجهيز الإجابات',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _currentIndex {
    final value = (_controller.value * messages.length).floor();
    return value.clamp(0, messages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: CustomTextWidget(
            '${messages[_currentIndex]}...',
            key: ValueKey(_currentIndex),
            fontSize: SizeConfig.text(0.031),
            fontWeight: FontWeight.w800,
            color: widget.isDark
                ? AppPalette.titleWhiteINDark
                : AppPalette.greyMedium,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}