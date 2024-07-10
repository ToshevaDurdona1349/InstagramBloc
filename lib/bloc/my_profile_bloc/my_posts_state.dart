
import '../../model/post_model.dart';

abstract class MyPostsState {}

class MyPostsInitialState extends MyPostsState {}

class MyPostsLoadingState extends MyPostsState {}

class MyPostsSuccessState extends MyPostsState {
  List<Post> items;

  MyPostsSuccessState({required this.items});
}

class MyPostsFailureState extends MyPostsState {
  final String errorMessage;

  MyPostsFailureState(this.errorMessage);
}

class RemoveMyPostState extends MyPostsState {
}
