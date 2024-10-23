

class BookModel extends Book {
  BookModel({
    required String id,
    required String title, 
    required String author,
    required String description,
    required String fileUrl,
  });
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      fileUrl: map['fileUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'fileUrl': fileUrl,
    };
  }
}
