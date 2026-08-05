import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/features/search/presentation/widgets/search_history_chip.dart';
import 'package:quiz_app_grad/features/search/presentation/widgets/search_history_header.dart';

class SearchHistorySection extends StatelessWidget {
  final List<SearchHistoryUiModel> histories;
  final ValueChanged<SearchHistoryUiModel> onHistoryTap;
  final ValueChanged<SearchHistoryUiModel> onDeleteHistory;
  final VoidCallback onClearAll;

  const SearchHistorySection({
    super.key,
    required this.histories,
    required this.onHistoryTap,
    required this.onDeleteHistory,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SearchHistoryHeader(onClearAll: onClearAll),
        const SizedBox(height: 8),
        if (histories.isEmpty)
          const EmptyActionBox(
            icon: Icons.history_rounded,
            title: 'لا يوجد سجل بحث',
            description: 'ستظهر هنا عمليات البحث التي تجريها',
          )
        else
          Wrap(
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            textDirection: TextDirection.rtl,
            children: histories.map((history) {
              return SearchHistoryChip(
                historyId: history.id,
                query: history.query,
                onTap: () => onHistoryTap(history),
                onDelete: () => onDeleteHistory(history),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class SearchHistoryUiModel {
  final int id;
  final String query;

  const SearchHistoryUiModel({required this.id, required this.query});
}
