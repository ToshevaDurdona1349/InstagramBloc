
import 'package:equatable/equatable.dart';

import '../../model/post_model.dart';

abstract class MyLikedEvent extends Equatable {
  const MyLikedEvent();
}

class LoadLikedPostsEvent extends MyLikedEvent {
  @override
  List<Object> get props => [];
}

class UnLikePostEvent extends MyLikedEvent {
  Post post;

  UnLikePostEvent({required this.post});

  @override
  List<Object> get props => [];
}

class RemovePostEvent extends MyLikedEvent {
  Post post;

  RemovePostEvent({required this.post});

  @override
  List<Object> get props => [];
}

