class SearchUsersParams {
  final String query;
  final String? cursor;

  const SearchUsersParams({required this.query, this.cursor});

  Map<String, dynamic> toQueryParameters() {
    final parameters = <String, dynamic>{'query': query.trim()};

    if (cursor != null && cursor!.trim().isNotEmpty) {
      parameters['cursor'] = cursor;
    }

    return parameters;
  }
}
