enum MainLayoutTab { home, library, laboratory, studyPlan }

class MainLayoutRouteArgs {
  final MainLayoutTab initialTab;

  const MainLayoutRouteArgs({this.initialTab = MainLayoutTab.home});

  static const studyPlan = MainLayoutRouteArgs(
    initialTab: MainLayoutTab.studyPlan,
  );
}
