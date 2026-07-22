import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchHistoryHeader(
            onClearAll: onClearAll,
          ),
          const SizedBox(height: 8),
          if (histories.isEmpty)
            const _EmptySearchHistory()
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
      ),
    );
  }
}

class _EmptySearchHistory extends StatelessWidget {
  const _EmptySearchHistory();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 52,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'لا يوجد سجل بحث حتى الآن',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchHistoryUiModel {
  final int id;
  final String query;

  const SearchHistoryUiModel({
    required this.id,
    required this.query,
  });
}