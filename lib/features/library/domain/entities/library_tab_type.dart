enum LibraryTabType {
  trending,
  newest,
  mostDownloaded;

  String get apiValue {
    switch (this) {
      case LibraryTabType.trending:
        return 'trending';
      case LibraryTabType.newest:
        return 'newest';
      case LibraryTabType.mostDownloaded:
        return 'most_downloaded';
    }
  }
}