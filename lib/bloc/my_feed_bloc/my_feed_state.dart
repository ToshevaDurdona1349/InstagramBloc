import '../../model/post_model.dart';

abstract class MyFeedState {}

class MyFeedInitialState extends MyFeedState {}

class MyFeedLoadingState extends MyFeedState {}

class MyFeedSuccessState extends MyFeedState {
  List<Post> items;

  MyFeedSuccessState({required this.items});
}

class MyFeedFailureState extends MyFeedState {
  final String errorMessage;

  MyFeedFailureState(this.errorMessage);
}

class RemoveFeedPostState extends MyFeedState {
  RemoveFeedPostState();
}
