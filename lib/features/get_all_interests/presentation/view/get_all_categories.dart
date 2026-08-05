import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_state.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/manager/all_categories_cubit/all_interests_cubit.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/widget/all_categories_content.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/widget/all_categories_header.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/widget/categories_search_field.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const AllCategoriesHeader(),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.045),
                  vertical: SizeConfig.h(0.012),
                ),
                child: CategoriesSearchField(
                  onChanged: (value) {
                    context.read<AllInterestsCubit>().changeSearchText(value);
                  },
                  onClear: () {
                    context.read<AllInterestsCubit>().clearSearch();
                  },
                ),
              ),

              Expanded(
                child: BlocBuilder<AllInterestsCubit, AllInterestsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.errorMessage != null) {
                      return Center(
                        child: CustomTextWidget(
                          'حدث خطأ أثناء جلب التصنيفات',
                          color: AppPalette.greyMedium,
                        ),
                      );
                    }

                    if (state.filteredCategories.isEmpty) {
                      return const Center(
                        child: EmptyActionBox(
                          icon: Icons.search_off_rounded,
                          title: 'لا توجد نتائج',
                          description: 'لم نعثر على تصنيفات مطابقة لبحثك',
                        ),
                      );
                    }

                    return AllCategoriesContent(
                      categories: state.filteredCategories,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
