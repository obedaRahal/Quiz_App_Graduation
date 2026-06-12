int parseCompactCount(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;
  if (value is double) return value.toInt();

  final text = value.toString().trim().toLowerCase();

  if (text.isEmpty) return 0;

  if (text.endsWith('k')) {
    final number = double.tryParse(text.replaceAll('k', '').trim()) ?? 0;
    return (number * 1000).round();
  }

  if (text.endsWith('m')) {
    final number = double.tryParse(text.replaceAll('m', '').trim()) ?? 0;
    return (number * 1000000).round();
  }

  return int.tryParse(text.replaceAll(',', '')) ?? 0;
}

String formatCompactCount(int value) {
  if (value >= 1000000) {
    final result = value / 1000000;
    return result % 1 == 0
        ? '${result.toInt()}M'
        : '${result.toStringAsFixed(1)}M';
  }

  if (value >= 1000) {
    final result = value / 1000;
    return result % 1 == 0
        ? '${result.toInt()}K'
        : '${result.toStringAsFixed(1)}K';
  }

  return value.toString();
}
