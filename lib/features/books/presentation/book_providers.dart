import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/books/data/repository/book_repository_impl.dart';
import 'package:devotion/features/books/domain/repository/book_repository.dart';
import 'package:devotion/features/books/domain/usecases/upload_book_usecase.dart';
import 'package:devotion/features/books/presentation/book_upload_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'book_upload_notifier.dart';

// Firebase Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Repository provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return BookRepositoryImpl(firestore);
});

// Use case provider
final uploadBookUseCaseProvider = Provider<UploadBookUseCase>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return UploadBookUseCase(repository);
});

// Book upload state notifier provider
final bookUploadNotifierProvider = StateNotifierProvider<BookUploadNotifier, BookUploadState>((ref) {
  final useCase = ref.watch(uploadBookUseCaseProvider);
  return BookUploadNotifier(useCase);
});
