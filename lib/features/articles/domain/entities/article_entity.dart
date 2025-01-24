// // article_entity.dart
// class ArticleEntity {
//   final String id;
//   final String title;
//   final String content;
//   final DateTime createdAt;

//   ArticleEntity({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.createdAt,
//   });
// }



class ArticleEntity {
final String id;
  final String title;
final DateTime createdAt;
  final String content;



  ArticleEntity({
 required this.id,
    required this.title,
required this.createdAt,
    required this.content,

  });



  factory ArticleEntity.fromJson(Map<String, dynamic> json) {

    return ArticleEntity(

      title: json['title'] as String,
id: json['id'] as String,
createdAt: DateTime.parse(json['createdAt'] as String),
      content: json['content'] as String,

    );

  }

}
