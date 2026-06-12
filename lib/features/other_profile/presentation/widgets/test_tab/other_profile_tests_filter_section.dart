// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
// import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_filter_item.dart';

// class OtherProfileTestsFilterSection extends StatelessWidget {
//   final OtherProfileTestsFilter selectedFilter;
//   final ValueChanged<OtherProfileTestsFilter> onFilterSelected;

//   const OtherProfileTestsFilterSection({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterSelected,
//   });

//   static const filters = [
//     _OtherProfileTestsFilterItem(
//       title: 'مدفوعة',
//       filter: OtherProfileTestsFilter.paid,
//     ),
//     _OtherProfileTestsFilterItem(
//       title: 'مجانية',
//       filter: OtherProfileTestsFilter.free,
//     ),
//     _OtherProfileTestsFilterItem(
//       title: 'الأحدث',
//       filter: OtherProfileTestsFilter.latest,
//     ),
//     _OtherProfileTestsFilterItem(
//       title: 'الأكثر تقدمًا',
//       filter: OtherProfileTestsFilter.mostTaken,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           textDirection: TextDirection.rtl,
//           children: filters.map((item) {
//             return Padding(
//               padding: EdgeInsets.only(left: SizeConfig.w(0.03)),
//               child: OtherProfileFilterItem(
//                 title: item.title,
//                 isSelected: selectedFilter == item.filter,
//                 onTap: () => onFilterSelected(item.filter),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

// class _OtherProfileTestsFilterItem {
//   final String title;
//   final OtherProfileTestsFilter filter;

//   const _OtherProfileTestsFilterItem({
//     required this.title,
//     required this.filter,
//   });
// }

// class OtherProfileFilterItem extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const OtherProfileFilterItem({
//     super.key,
//     required this.title,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final fontSize = SizeConfig.text(0.033).clamp(11.0, 14.0);
//     final horizontalPadding = SizeConfig.w(0.035);
//     final verticalPadding = SizeConfig.h(0.003);
//     final borderRadius = SizeConfig.w(0.04).clamp(10.0, 16.0);

//     final selectedColor = Theme.of(context).colorScheme.primary;
//     final unselectedColor = isDark
//         ? AppPalette.greyMediumDark
//         : AppPalette.whiteToGrey;

//     final textSelectedColor = isDark ? AppPalette.black : AppPalette.white;
//     final textUnselectedColor = isDark
//         ? AppPalette.titleWhiteINDark
//         : AppPalette.greyMedium;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(borderRadius),
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 220),
//           curve: Curves.easeInOut,
//           constraints: BoxConstraints(minWidth: SizeConfig.w(0.18)),
//           padding: EdgeInsets.symmetric(
//             horizontal: horizontalPadding,
//             vertical: verticalPadding,
//           ),
//           decoration: BoxDecoration(
//             color: isSelected ? selectedColor : unselectedColor,
//             borderRadius: BorderRadius.circular(borderRadius),
//           ),
//           child: Center(
//             child: CustomTextWidget(
//               title,
//               fontSize: fontSize,
//               color: isSelected ? textSelectedColor : textUnselectedColor,
//               fontWeight: FontWeight.w500,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class OtherProfileTestsFilterSection extends StatelessWidget {
  final OtherProfileTestsFilter selectedFilter;
  final ValueChanged<OtherProfileTestsFilter> onFilterSelected;

  const OtherProfileTestsFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'مدفوعة',
      value: OtherProfileTestsFilter.paid,
    ),
    OtherProfileFilterOption(
      title: 'مجانية',
      value: OtherProfileTestsFilter.free,
    ),
    OtherProfileFilterOption(
      title: 'الأحدث',
      value: OtherProfileTestsFilter.latest,
    ),
    OtherProfileFilterOption(
      title: 'الأكثر تقدمًا',
      value: OtherProfileTestsFilter.mostTaken,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OtherProfileHorizontalFilterSection<OtherProfileTestsFilter>(
      selectedFilter: selectedFilter,
      filters: filters,
      onFilterSelected: onFilterSelected,
    );
  }
}
