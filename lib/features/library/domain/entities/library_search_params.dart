class LibrarySearchParams {
  final String query;
  final int perPage;
  final String mode;
  final String? cursor;

  const LibrarySearchParams({
    required this.query,
    this.perPage = 20,
    this.mode = 'all_public',
    this.cursor,
  });

  Map<String, dynamic> toQuery() {
    return {
      'query': query,
      'mode': mode,
      'per_page': perPage,
      if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
    };
  }
}