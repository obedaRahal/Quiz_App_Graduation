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
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_cubit.dart';

class AiGenerationStatusCard extends StatelessWidget {
  const AiGenerationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiGenerationCubit, AiGenerationState>(
      listenWhen: (previous, current) {
        return previous.task?.requestId != current.task?.requestId &&
            current.task != null;
      },
      listener: (context, state) {
        context.read<LaboratoryCubit>().getAiGenerationDailyLimit();
      },
      builder: (context, state) {
        if (state.phase == AiGenerationPhase.idle) {
          return const SizedBox.shrink();
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final appColors = context.appColors;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(0.03),
            SizeConfig.h(0.006),
            SizeConfig.w(0.03),
            SizeConfig.h(0.010),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openTask(context, state),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.035),
                  vertical: SizeConfig.h(0.012),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppPalette.fieldColorNDark
                      : AppPalette.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppPalette.borderFieldColorNDark
                        : appColors.primaryToPrimaryDark.withValues(
                            alpha: 0.22,
                          ),
                  ),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.w(0.090),
                      height: SizeConfig.w(0.090),
                      decoration: BoxDecoration(
                        color: appColors.primaryToPrimaryDark.withValues(
                          alpha: 0.12,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _iconFor(state),
                        color: _iconColor(context, state),
                        size: SizeConfig.text(0.045),
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(0.025)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          _titleFor(state),
                          fontSize: SizeConfig.text(0.032),
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? AppPalette.textWhiteINDark
                              : AppPalette.textColorInHome,
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: SizeConfig.h(0.004)),
                        CustomTextWidget(
                          _subtitleFor(state),
                          fontSize: SizeConfig.text(0.026),
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppPalette.grey2Dark
                              : AppPalette.greyMedium,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.chevron_left_rounded,
                      color: appColors.primaryToPrimaryDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openTask(BuildContext context, AiGenerationState state) {
    if (state.isCompleted && state.editorArgs != null) {
      context.pushNamed(AppRouterName.createTestPage, extra: state.editorArgs);
      return;
    }

    final args = context.read<AiGenerationCubit>().loadingArgs;
    if (args != null) {
      context.pushNamed(AppRouterName.createTestAiLoadingPage, extra: args);
    }
  }

  String _titleFor(AiGenerationState state) {
    return switch (state.phase) {
      AiGenerationPhase.uploading => 'جاري رفع ملف التوليد',
      AiGenerationPhase.processing => 'جاري توليد الأسئلة',
      AiGenerationPhase.waitingForConnection => 'تعذر متابعة حالة التوليد',
      AiGenerationPhase.completed => 'اكتمل توليد الأسئلة',
      AiGenerationPhase.failed => 'فشلت عملية التوليد',
      AiGenerationPhase.idle => '',
    };
  }

  String _subtitleFor(AiGenerationState state) {
    if (state.isUploading && state.uploadProgress != null) {
      return 'تم رفع ${(state.uploadProgress! * 100).round()}% — يمكنك متابعة استخدام التطبيق';
    }

    if (state.actuallyGenerated > 0) {
      final requested = state.requestedQuestionCount > 0
          ? state.requestedQuestionCount
          : state.task?.questionCount ?? 0;
      return 'تم تجهيز ${state.actuallyGenerated} من $requested سؤالًا';
    }

    if (state.isCompleted) return 'اضغط لمراجعة الأسئلة وتعديلها';
    if (state.errorMessage?.trim().isNotEmpty == true) {
      return state.errorMessage!;
    }

    return 'يمكنك متابعة استخدام التطبيق وسنحتفظ بالنتيجة';
  }

  IconData _iconFor(AiGenerationState state) {
    return switch (state.phase) {
      AiGenerationPhase.uploading => Icons.cloud_upload_outlined,
      AiGenerationPhase.processing => Icons.auto_awesome_rounded,
      AiGenerationPhase.waitingForConnection => Icons.cloud_off_outlined,
      AiGenerationPhase.completed => Icons.check_circle_outline_rounded,
      AiGenerationPhase.failed => Icons.error_outline_rounded,
      AiGenerationPhase.idle => Icons.hourglass_empty_rounded,
    };
  }

  Color _iconColor(BuildContext context, AiGenerationState state) {
    if (state.isCompleted) return AppPalette.green;
    if (state.isFailed) return AppPalette.red;
    return context.appColors.primaryToPrimaryDark;
  }
}
