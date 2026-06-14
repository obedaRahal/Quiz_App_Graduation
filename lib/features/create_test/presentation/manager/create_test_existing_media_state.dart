class CreateTestExistingMediaState {
  final int? id;
  final String name;
  final String url;
  final String type; // image / pdf / file

  const CreateTestExistingMediaState({
    this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  bool get isImage {
    final normalized = type.trim().toLowerCase();
    return normalized == 'image' ||
        normalized == 'images' ||
        normalized == 'صورة' ||
        normalized == 'صور' ||
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.webp');
  }

  bool get isPdf {
    final normalized = type.trim().toLowerCase();
    return normalized == 'pdf' ||
        normalized == 'file' ||
        normalized == 'ملف' ||
        url.toLowerCase().endsWith('.pdf');
  }
}