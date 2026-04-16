class InterestGroupOption {
  final int id;
  final String title;
  final List<InterestOption> items;

  const InterestGroupOption({
    required this.id,
    required this.title,
    required this.items,
  });
}

class InterestOption {
  final int id;
  final String name;

  const InterestOption({
    required this.id,
    required this.name,
  });
}