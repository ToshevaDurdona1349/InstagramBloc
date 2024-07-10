
abstract class MyPhotoState {}

class MyPhotoInitialState extends MyPhotoState {}

class MyPhotoLoadingState extends MyPhotoState {}

class MyPhotoSuccessState extends MyPhotoState {
}

class MyPhotoFailureState extends MyPhotoState {
  final String errorMessage;

  MyPhotoFailureState(this.errorMessage);
}