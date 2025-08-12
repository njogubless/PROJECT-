
class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String fileUrl;
  final String coverUrl;
  final String downloadUrl;
  final String storagePath;
  final String? fileName;
  final int? fileSize;
  final String? fileType;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.fileUrl,
    required this.coverUrl,
    required this.downloadUrl,
    required this.storagePath,
    this.fileName,
    this.fileSize,
    this.fileType,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    try {
      String actualTitle = json['title'] as String? ?? '';
      String fileName = json['fileName'] as String? ?? '';

      if (actualTitle.isEmpty && fileName.isNotEmpty) {
        actualTitle = fileName
            .replaceAll('.pdf', '')
            .replaceAll('(Z-Library)', '')
            .trim();
      }

      return BookModel(
        id: json['id'] as String? ?? '',
        title: actualTitle,
        author: json['author'] as String? ?? 'Unknown Author',
        description: json['description'] as String? ?? '',
        fileUrl:
            json['downloadUrl'] as String? ?? json['fileUrl'] as String? ?? '',
        coverUrl: json['coverUrl'] as String? ??
            _generatePlaceholderCover(actualTitle),
        downloadUrl: json['downloadUrl'] as String? ?? '',
        storagePath: json['storagePath'] as String? ?? '',
        fileName: fileName,
        fileSize: json['fileSize'] as int?,
        fileType: json['fileType'] as String?,
      );
    } catch (e) {
      print("Error parsing book: $e\nData: $json");
      rethrow;
    }
  }

  static String _generatePlaceholderCover(String title) {
    final encodedTitle = Uri.encodeComponent(title.isNotEmpty ? title : 'Book');
    return 'https://ui-avatars.com/api/?name=$encodedTitle&size=300&background=6366f1&color=white&format=png';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'fileUrl': fileUrl,
        'coverUrl': coverUrl,
        'downloadUrl': downloadUrl,
        'storagePath': storagePath,
        'fileName': fileName,
        'fileSize': fileSize,
        'fileType': fileType,
      };
}
