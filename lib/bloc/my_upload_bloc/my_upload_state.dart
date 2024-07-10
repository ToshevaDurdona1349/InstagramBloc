
abstract class MyUploadState {}

class MyUploadInitialState extends MyUploadState {}

class MyUploadLoadingState extends MyUploadState {}

class MyUploadSuccessState extends MyUploadState {
}

class MyUploadFailureState extends MyUploadState {
  final String errorMessage;

  MyUploadFailureState(this.errorMessage);
}
