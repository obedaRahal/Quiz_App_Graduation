import 'package:flutter/material.dart';

class SearchHistoryHeader extends StatelessWidget {
  final VoidCallback onClearAll;

  const SearchHistoryHeader({super.key, required this.onClearAll});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'سجل البحث',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: onClearAll,
          child: Text(
            'حذف السجل',
            style: TextStyle(
              color: colorScheme.error,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
