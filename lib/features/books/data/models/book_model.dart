class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final String fileUrl;
  final String coverUrl;
  final String downloadUrl;
  final String storagePath;

  // Constructor
  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.fileUrl,
    required this.coverUrl,
    required this.downloadUrl,
    required this.storagePath,
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
      storagePath: map['storagePath'] as String,
    );
  }

  // Factory method to create a BookModel from JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fileUrl: json['fileUrl'] as String? ?? '',
      coverUrl: json['coverUrl'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String? ?? '',
      storagePath: json['storagePath'] as String? ?? '',
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
      'storagePath': storagePath,
    };
  }

  // Method to convert the BookModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'fileUrl': fileUrl,
        'coverUrl': coverUrl,
        'downloadUrl': downloadUrl,
        'storagePath': storagePath,
      };
}
