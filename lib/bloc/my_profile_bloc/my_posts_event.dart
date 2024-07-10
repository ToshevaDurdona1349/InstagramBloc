
import 'package:equatable/equatable.dart';

import '../../model/post_model.dart';

abstract class MyPostsEvent extends Equatable {
  const MyPostsEvent();
}

class LoadMyPostsEvent extends MyPostsEvent {
  @override
  List<Object> get props => [];
}

class RemoveMyPostEvent extends MyPostsEvent {
  Post post;

  RemoveMyPostEvent({required this.post});

  @override
  List<Object> get props => [];
}