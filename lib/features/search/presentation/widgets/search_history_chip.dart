import 'package:flutter/material.dart';

class SearchHistoryChip extends StatelessWidget {
  final int historyId;
  final String query;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SearchHistoryChip({
    super.key,
    required this.historyId,
    required this.query,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 180,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Flexible(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 12,
                  end: 6,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(
                  query,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(
              minWidth: 30,
              minHeight: 30,
            ),
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.close,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 3),
        ],
      ),
    );
  }
}

