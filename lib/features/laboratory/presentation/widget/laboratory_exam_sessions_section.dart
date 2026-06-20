import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_cubit.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/manager/laboratory_cubit/laboratory_state.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_exam_session_card.dart';

class LaboratoryExamSessionsSection extends StatelessWidget {
  const LaboratoryExamSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaboratoryCubit, LaboratoryState>(
      buildWhen: (previous, current) {
        return previous.isInitialLoading != current.isInitialLoading ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.error != current.error ||
            previous.examSessions != current.examSessions ||
            previous.isSearchMode != current.isSearchMode ||
            previous.isSearchLoading != current.isSearchLoading ||
            previous.isSearchLoadingMore != current.isSearchLoadingMore ||
            previous.searchResults != current.searchResults ||
            previous.searchError != current.searchError ||
            previous.isFilterMode != current.isFilterMode ||
            previous.isFilterLoading != current.isFilterLoading ||
            previous.isFilterLoadingMore != current.isFilterLoadingMore ||
            previous.filterResults != current.filterResults ||
            previous.filterError != current.filterError;
      },
      builder: (context, state) {
        final isFilter = state.isFilterMode;
        final isSearch = state.isSearchMode;

        final sessions = isFilter
            ? state.filterResults
            : isSearch
            ? state.searchResults
            : state.examSessions;

        final isLoading = isFilter
            ? state.isFilterLoading
            : isSearch
            ? state.isSearchLoading
            : state.isInitialLoading;

        final error = isFilter
            ? state.filterError
            : isSearch
            ? state.searchError
            : state.error;

        if (isLoading) {
          return SizedBox(
            height: SizeConfig.h(0.25),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (error != null && sessions.isEmpty) {
          return SizedBox(
            height: SizeConfig.h(0.20),
            child: Center(
              child: CustomTextWidget(
                isFilter
                    ? 'لا توجد نتائج مطابقة لعملية البحث التي قمت بها'
                    : isSearch
                    ? 'حدث خطأ أثناء البحث'
                    : 'حدث خطأ أثناء جلب الجلسات الامتحانية',
                color: AppPalette.greyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (sessions.isEmpty) {
          return SizedBox(
            height: SizeConfig.h(0.20),
            child: Center(
              child: CustomTextWidget(
                isFilter
                    ? 'لا توجد نتائج مطابقة للفلتر'
                    : isSearch
                    ? (state.searchQuery.trim().isEmpty
                          ? 'يرجى ادخال اسم الاختبار للبحث'
                          : 'لا توجد نتائج مطابقة')
                    : 'لا توجد جلسات امتحانية حالياً',
                color: AppPalette.greyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final showBottomLoader = isFilter
            ? state.isFilterLoadingMore
            : isSearch
            ? state.isSearchLoadingMore
            : state.isLoadingMore || state.isLabTestsLoadingMore;

        return ListView.separated(
          padding: EdgeInsets.only(
            top: SizeConfig.h(0.012),
            bottom: SizeConfig.h(0.03),
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length + (showBottomLoader ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.018)),
          itemBuilder: (context, index) {
            if (index >= sessions.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            return LaboratoryExamSessionCard(item: sessions[index]);
          },
        );
      },
    );
  }
}
