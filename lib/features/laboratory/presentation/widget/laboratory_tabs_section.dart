// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_filter_item.dart';

// class LaboratoryTabsSection extends StatefulWidget {
//   const LaboratoryTabsSection({super.key});

//   @override
//   State<LaboratoryTabsSection> createState() => _LaboratoryTabsSectionState();
// }

// class _LaboratoryTabsSectionState extends State<LaboratoryTabsSection> {
//   int selectedIndex = 0;

//   void changeTab(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.w(0.036),
//       ),
//       child: Row(
//         textDirection: TextDirection.rtl,
//         children: [
//           Container(
//             width: SizeConfig.w(0.075),
//             height: SizeConfig.w(0.075),
//             decoration: BoxDecoration(
//               color: isDark
//                   ? AppPalette.fieldColorNDark
//                   : AppPalette.whiteToGrey,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               Icons.filter_alt_outlined,
//               size: SizeConfig.text(0.045),
//               color: AppPalette.greyMedium,
//             ),
//           ),

//           SizedBox(width: SizeConfig.w(0.025)),

//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               reverse: true,
//               child: Row(
//                 textDirection: TextDirection.rtl,
//                 children: [
//                   LaboratoryFilterItem(
//                     title: "رائج",
//                     index: 0,
//                     selectedIndex: selectedIndex,
//                     onTap: () => changeTab(0),
//                   ),
//                   SizedBox(width: SizeConfig.w(0.03)),

//                   LaboratoryFilterItem(
//                     title: "مجاني",
//                     index: 3,
//                     selectedIndex: selectedIndex,
//                     onTap: () => changeTab(3),
//                   ),
//                   SizedBox(width: SizeConfig.w(0.03)),

//                   LaboratoryFilterItem(
//                     title: "جديد",
//                     index: 1,
//                     selectedIndex: selectedIndex,
//                     onTap: () => changeTab(1),
//                   ),
//                   SizedBox(width: SizeConfig.w(0.03)),

//                   LaboratoryFilterItem(
//                     title: "الأكثر تقدما",
//                     index: 2,
//                     selectedIndex: selectedIndex,
//                     onTap: () => changeTab(2),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/widget/laboratory_filter_item.dart';

class LaboratoryTabsSection extends StatefulWidget {
  const LaboratoryTabsSection({super.key});

  @override
  State<LaboratoryTabsSection> createState() => _LaboratoryTabsSectionState();
}

class _LaboratoryTabsSectionState extends State<LaboratoryTabsSection> {
  int selectedIndex = 0;

  void changeTab(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.036)),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: LaboratoryFilterItem(
                    title: "رائج",
                    index: 0,
                    selectedIndex: selectedIndex,
                    onTap: () => changeTab(0),
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.018)),

                Expanded(
                  child: LaboratoryFilterItem(
                    title: "مجاني",
                    index: 3,
                    selectedIndex: selectedIndex,
                    onTap: () => changeTab(3),
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.018)),

                Expanded(
                  child: LaboratoryFilterItem(
                    title: "جديد",
                    index: 1,
                    selectedIndex: selectedIndex,
                    onTap: () => changeTab(1),
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.018)),

                Expanded(
                  flex: 2,
                  child: LaboratoryFilterItem(
                    title: "الأكثر تقدما",
                    index: 2,
                    selectedIndex: selectedIndex,
                    onTap: () => changeTab(2),
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.092)),
                Container(
                  width: SizeConfig.w(0.075),
                  height: SizeConfig.w(0.075),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.fieldColorNDark
                        : AppPalette.whiteToGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    size: SizeConfig.text(0.045),
                    color: AppPalette.greyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
