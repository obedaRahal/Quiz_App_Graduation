import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_filter_item.dart';

class LibraryTabsSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  const LibraryTabsSection({
    super.key,
    this.selectedIndex = 0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.036)),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                LibraryFilterItem(
                  title: "رائج",
                  index: 0,
                  selectedIndex: selectedIndex,
                  onTap: () => onChanged?.call(0),
                ),

                SizedBox(width: SizeConfig.w(0.018)),

                LibraryFilterItem(
                  title: "جديد",
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: () => onChanged?.call(1),
                ),

                SizedBox(width: SizeConfig.w(0.018)),

                LibraryFilterItem(
                  title: "الأكثر تحميلا",
                  index: 2,
                  selectedIndex: selectedIndex,
                  onTap: () => onChanged?.call(2),
                ),

                SizedBox(width: SizeConfig.w(0.092)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}