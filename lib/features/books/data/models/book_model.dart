class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String fileUrl;
  final String coverUrl;
  final String downloadUrl;

  // Constructor
  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.fileUrl,
    required this.coverUrl,
    required this.downloadUrl,
  });

  // Factory method to create a BookModel from a map
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      description: map['description'] as String,
      fileUrl: map['fileUrl'] as String,
      coverUrl: map['coverUrl'] as String,
      downloadUrl: map['downloadUrl'] as String,
    );
  }

  // Method to convert the BookModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'fileUrl': fileUrl,
      'downloadUrl': downloadUrl,
      'coverUrl': coverUrl,
    };
  }
}
