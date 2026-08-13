class FetchPurchasedTestsParams {
  final String tab;

  const FetchPurchasedTestsParams({required this.tab});

  Map<String, dynamic> toQueryParameters() => {'tab': tab};
}
