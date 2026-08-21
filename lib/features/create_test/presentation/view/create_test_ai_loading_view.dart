import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/ai_generation/ai_generation_cubit.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/ai_generation/ai_generation_state.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';

class CreateTestAiLoadingView extends StatefulWidget {
  final CreateTestInitialArgs args;

  const CreateTestAiLoadingView({super.key, required this.args});

  @override
  State<CreateTestAiLoadingView> createState() =>
      _CreateTestAiLoadingViewState();
}

class _CreateTestAiLoadingViewState extends State<CreateTestAiLoadingView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<AiGenerationCubit>();
      if (cubit.state.phase == AiGenerationPhase.idle) {
        cubit.startGeneration(widget.args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiGenerationCubit, AiGenerationState>(
      listenWhen: (previous, current) {
        return !previous.isCompleted && current.isCompleted;
      },
      listener: (context, state) {
        final editorArgs = state.editorArgs;
        if (editorArgs != null) {
          context.pushReplacementNamed(
            AppRouterName.createTestPage,
            extra: editorArgs,
          );
        }
      },
      child: _CreateTestAiLoadingContent(args: widget.args),
    );
  }
}

class _CreateTestAiLoadingContent extends StatelessWidget {
  final CreateTestInitialArgs args;

  const _CreateTestAiLoadingContent({required this.args});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;
    final state = context.watch<AiGenerationCubit>().state;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: isDark ? AppPalette.black : AppPalette.white,
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(0.055),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: SizeConfig.h(0.030)),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () => context.pop(),
                                borderRadius: BorderRadius.circular(30),
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
                                    Icons.close_rounded,
                                    size: SizeConfig.text(0.044),
                                    color: appColors.primaryToPrimaryDark,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            const _AiLoadingAnimation(),

                            SizedBox(height: SizeConfig.h(0.045)),

                            CustomTextWidget(
                              _titleFor(state),
                              fontSize: SizeConfig.text(0.050),
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? AppPalette.textWhiteINDark
                                  : AppPalette.textColorInHome,
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: SizeConfig.h(0.010)),

                            CustomTextWidget(
                              _subtitleFor(state),
                              fontSize: SizeConfig.text(0.032),
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppPalette.grey2Dark
                                  : AppPalette.greyMedium,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),

                            SizedBox(height: SizeConfig.h(0.030)),

                            _GenerationInfoCard(args: args),

                            SizedBox(height: SizeConfig.h(0.035)),

                            _GenerationProgress(state: state, isDark: isDark),

                            const Spacer(),

                            _GenerationActions(state: state),

                            SizedBox(height: SizeConfig.h(0.016)),

                            Padding(
                              padding: EdgeInsets.only(
                                bottom: SizeConfig.h(0.030),
                              ),
                              child: CustomTextWidget(
                                state.isUploading
                                    ? 'يمكنك مغادرة الصفحة، وتجنب إغلاق التطبيق بالقوة حتى يكتمل رفع الملف.'
                                    : 'يمكنك متابعة استخدام التطبيق وسنحتفظ بهذه المهمة داخل المختبر.',
                                fontSize: SizeConfig.text(0.028),
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppPalette.grey2Dark
                                    : AppPalette.greyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _titleFor(AiGenerationState state) {
    return switch (state.phase) {
      AiGenerationPhase.uploading => 'جاري رفع الملفات',
      AiGenerationPhase.processing => 'يتم توليد الأسئلة الآن',
      AiGenerationPhase.waitingForConnection => 'بانتظار استعادة الاتصال',
      AiGenerationPhase.completed => 'اكتمل توليد الأسئلة',
      AiGenerationPhase.failed => 'تعذر توليد الأسئلة',
      AiGenerationPhase.idle => 'تجهيز طلب التوليد',
    };
  }

  String _subtitleFor(AiGenerationState state) {
    if (state.errorMessage?.trim().isNotEmpty == true) {
      return state.errorMessage!;
    }

    if (state.isUploading) {
      return 'نرفع ${args.isAiImages ? 'الصور' : 'الملف'} أولًا، ثم ستتابع عملية التوليد على الخادم.';
    }

    if (state.isCompleted) {
      return 'أصبحت الأسئلة جاهزة للمراجعة والتعديل قبل إنشاء الاختبار.';
    }

    if (state.isFailed) {
      return 'لم تكتمل المهمة. يمكنك العودة إلى المختبر وإنشاء طلب جديد.';
    }

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
                  size: Size(SizeConfig.w(0.58), SizeConfig.w(0.58)),
                  painter: _OrbitPainter(
                    color: appColors.primaryToPrimaryDark.withValues(
                      alpha: 0.22,
                    ),
                  ),
                ),
              ),

              ...List.generate(4, (index) {
                final angle = (value * math.pi * 2) + (index * math.pi / 2);

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
                          color: appColors.primaryToPrimaryDark.withValues(
                            alpha: isDark ? 0.20 : 0.28,
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
                          : appColors.primaryToPrimaryDark.withValues(
                              alpha: 0.25,
                            ),
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

  const _OrbitPainter({required this.color});

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

  const _GenerationInfoCard({required this.args});

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
            color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.035),
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
          _InfoRow(title: 'المستوى', value: args.aiLevel ?? 'سهل'),
          SizedBox(height: SizeConfig.h(0.010)),
          _InfoRow(title: 'اللغة', value: args.aiLanguage ?? 'عربية'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

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

class _GenerationProgress extends StatelessWidget {
  final AiGenerationState state;
  final bool isDark;

  const _GenerationProgress({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final progress = state.isUploading
        ? state.uploadProgress
        : state.generationProgress;
    final requested = state.requestedQuestionCount > 0
        ? state.requestedQuestionCount
        : state.task?.questionCount ?? 0;
    final label = state.isUploading
        ? (progress == null
              ? 'جاري رفع الملفات...'
              : 'تم رفع ${(progress * 100).round()}%')
        : state.actuallyGenerated > 0 && requested > 0
        ? 'تم تجهيز ${state.actuallyGenerated} من $requested سؤالًا'
        : state.phase == AiGenerationPhase.waitingForConnection
        ? 'سنستأنف التحقق عند توفر الاتصال'
        : 'طلبك قيد المعالجة على الخادم';

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: isDark
                ? AppPalette.greyMediumDark
                : AppPalette.primarySoft,
            color: context.appColors.primaryToPrimaryDark,
          ),
        ),
        SizedBox(height: SizeConfig.h(0.012)),
        CustomTextWidget(
          label,
          fontSize: SizeConfig.text(0.031),
          fontWeight: FontWeight.w800,
          color: isDark ? AppPalette.titleWhiteINDark : AppPalette.greyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _GenerationActions extends StatelessWidget {
  final AiGenerationState state;

  const _GenerationActions({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isCompleted && state.editorArgs != null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.pushReplacementNamed(
              AppRouterName.createTestPage,
              extra: state.editorArgs,
            );
          },
          child: const Text('مراجعة الأسئلة'),
        ),
      );
    }

    if (state.phase == AiGenerationPhase.waitingForConnection) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('متابعة استخدام التطبيق'),
            ),
          ),
          SizedBox(width: SizeConfig.w(0.025)),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.read<AiGenerationCubit>().refresh(),
              child: const Text('إعادة التحقق'),
            ),
          ),
        ],
      );
    }

    if (state.isFailed) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await context.read<AiGenerationCubit>().clearTask();
            if (context.mounted) context.pop();
          },
          child: const Text('العودة إلى المختبر'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text('متابعة استخدام التطبيق'),
      ),
    );
  }
}
