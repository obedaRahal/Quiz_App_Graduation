import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/widget/interest_category_group.dart';

class AllCategoriesContent extends StatelessWidget {
  final List<InterestCategoryEntity> categories;

  const AllCategoriesContent({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        left: SizeConfig.w(0.045),
        right: SizeConfig.w(0.045),
        bottom: SizeConfig.h(0.03),
      ),
      itemCount: categories.length,
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.022)),
      itemBuilder: (context, index) {
        return InterestCategoryGroup(
          category: categories[index],
        );
      },
    );
  }
}