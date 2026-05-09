import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_state.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_exam_session_card.dart';

class LaboratoryExamSessionsSection extends StatelessWidget {
  const LaboratoryExamSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaboratoryCubit, LaboratoryState>(
      buildWhen: (previous, current) =>
          previous.isInitialLoading != current.isInitialLoading ||
          previous.isLoadingMore != current.isLoadingMore ||
          previous.error != current.error ||
          previous.examSessions != current.examSessions ||
          previous.isSearchMode != current.isSearchMode ||
          previous.isSearchLoading != current.isSearchLoading ||
          previous.searchResults != current.searchResults ||
          previous.searchError != current.searchError,
      builder: (context, state) {
        final isSearch = state.isSearchMode;

        final sessions = isSearch ? state.searchResults : state.examSessions;
        if (isSearch ? state.isSearchLoading : state.isInitialLoading) {
          return SizedBox(
            height: SizeConfig.h(0.25),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if ((isSearch ? state.searchError : state.error) != null &&
            sessions.isEmpty) {
          return SizedBox(
            height: SizeConfig.h(0.20),
            child: Center(
              child: CustomTextWidget(
                'حدث خطأ أثناء جلب الجلسات الامتحانية',
                color: AppPalette.greyMedium,
              ),
            ),
          );
        }
        if (sessions.isEmpty) {
          return SizedBox(
            height: SizeConfig.h(0.20),
            child: Center(
              child: CustomTextWidget(
                isSearch
                    ? (state.searchQuery.trim().isEmpty
                          ? 'يرجى ادخال اسم الاختبار للبحث'
                          : 'لا توجد نتائج مطابقة')
                    : 'لا توجد جلسات امتحانية حالياً',
                color: AppPalette.greyMedium,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(
            top: SizeConfig.h(0.012),
            bottom: SizeConfig.h(0.03),
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.018)),
          itemBuilder: (context, index) {
            return LaboratoryExamSessionCard(item: sessions[index]);
          },
        );
      },
    );
  }
}
