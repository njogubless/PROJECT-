abstract class BookUploadState {}

class BookUploadInitial extends BookUploadState {}

class BookUploadLoading extends BookUploadState {}

class BookUploadSuccess extends BookUploadState {}

class BookUploadFailure extends BookUploadState {
  final String error;

  BookUploadFailure(this.error);
}
