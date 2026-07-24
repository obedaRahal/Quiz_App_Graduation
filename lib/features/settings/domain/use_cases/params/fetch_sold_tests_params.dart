class FetchSoldTestsParams {
  final String tab;

  const FetchSoldTestsParams({required this.tab});

  Map<String, dynamic> toQueryParameters() {
    return {'tab': tab};
  }
}
