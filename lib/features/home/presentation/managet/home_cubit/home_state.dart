class HomeState {
  final int pageIndex;     // 🔵 للـ PageView
  final int filterIndex;   // 🟢 للفلاتر

  const HomeState({
    this.pageIndex = 0,
    this.filterIndex = 0,
  });

  HomeState copyWith({
    int? pageIndex,
    int? filterIndex,
  }) {
    return HomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      filterIndex: filterIndex ?? this.filterIndex,
    );
  }
}