import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String fileName;
  final String fileUrl;
  final String downloadUrl;
  final String storagePath;
  final String coverUrl;
  final int fileSize;
  final Timestamp uploadDate;
  final String description;
  final String category;
  final bool isDownloaded;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.fileName,
    required this.fileUrl,
    required this.downloadUrl,
    required this.storagePath,
    required this.coverUrl,
    required this.fileSize,
    required this.uploadDate,
    this.description = '',
    this.category = 'General',
    this.isDownloaded = false,
  });

  // Factory constructor from Firestore document
  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return BookModel(
      id: doc.id,
      title: _getStringValue(data, 'title') ?? 
             _getStringValue(data, 'fileName') ?? 
             'Unknown Title',
      author: _getStringValue(data, 'author') ?? 
              _getStringValue(data, 'authorName') ?? 
              'Unknown Author',
      fileName: _getStringValue(data, 'fileName') ?? 
                '${_getStringValue(data, 'title') ?? 'book'}.pdf',
      fileUrl: _getStringValue(data, 'fileUrl') ?? 
               _getStringValue(data, 'downloadUrl') ?? 
               '',
      downloadUrl: _getStringValue(data, 'downloadUrl') ?? 
                   _getStringValue(data, 'fileUrl') ?? 
                   '',
      storagePath: _getStringValue(data, 'storagePath') ?? 
                   _getStringValue(data, 'filePath') ?? 
                   '',
      coverUrl: _getStringValue(data, 'coverUrl') ?? 
                _getStringValue(data, 'thumbnailUrl') ?? 
                '',
      fileSize: _getIntValue(data, 'fileSize') ?? 0,
      uploadDate: data['uploadDate'] as Timestamp? ?? 
                  data['uploadedAt'] as Timestamp? ??
                  Timestamp.now(),
      description: _getStringValue(data, 'description') ?? '',
      category: _getStringValue(data, 'category') ?? 'General',
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'downloadUrl': downloadUrl,
      'storagePath': storagePath,
      'coverUrl': coverUrl,
      'fileSize': fileSize,
      'uploadDate': uploadDate,
      'description': description,
      'category': category,
    };
  }

  // Create a copy with updated fields
  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? fileName,
    String? fileUrl,
    String? downloadUrl,
    String? storagePath,
    String? coverUrl,
    int? fileSize,
    Timestamp? uploadDate,
    String? description,
    String? category,
    bool? isDownloaded,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      storagePath: storagePath ?? this.storagePath,
      coverUrl: coverUrl ?? this.coverUrl,
      fileSize: fileSize ?? this.fileSize,
      uploadDate: uploadDate ?? this.uploadDate,
      description: description ?? this.description,
      category: category ?? this.category,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  // Get the primary download URL (prefer downloadUrl over fileUrl)
  String get primaryDownloadUrl {
    if (downloadUrl.isNotEmpty) return downloadUrl;
    if (fileUrl.isNotEmpty) return fileUrl;
    return '';
  }

  // Check if book has a valid download URL
  bool get hasValidDownloadUrl {
    return primaryDownloadUrl.isNotEmpty;
  }

  // Get formatted file size
  String get formattedFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Get formatted upload date
  String get formattedUploadDate {
    final dateTime = uploadDate.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  String toString() {
    return 'BookModel(id: $id, title: $title, author: $author, fileName: $fileName, hasValidUrl: $hasValidDownloadUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Helper functions
String? _getStringValue(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value == null) return null;
  if (value is String) return value.isNotEmpty ? value : null;
  return value.toString().isNotEmpty ? value.toString() : null;
}

int? _getIntValue(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}