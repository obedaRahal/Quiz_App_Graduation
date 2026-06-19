import 'library_tab_type.dart';

class LibraryParams {
  final LibraryTabType tab;
  final int perPage;
  final String? cursor;

  const LibraryParams({
    required this.tab,
    this.perPage = 20,
    this.cursor,
  });

  Map<String, dynamic> toQuery() {
    return {
      'tab': tab.apiValue,
      'per_page': perPage,
      if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
    };
  }
}