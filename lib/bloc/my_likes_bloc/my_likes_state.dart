import '../../model/post_model.dart';

abstract class MyLikedState {}

class MyLikedInitialState extends MyLikedState {}

class MyLikedLoadingState extends MyLikedState {}

class MyLikedSuccessState extends MyLikedState {
  List<Post> items;

  MyLikedSuccessState({required this.items});
}

class MyLikedFailureState extends MyLikedState {
  final String errorMessage;

  MyLikedFailureState(this.errorMessage);
}

class UnLikePostSuccessState extends MyLikedState {
}

class RemovePostSuccessState extends MyLikedState {
}
