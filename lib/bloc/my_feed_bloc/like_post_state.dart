import 'package:equatable/equatable.dart';

import '../../model/post_model.dart';

abstract class LikeState extends Equatable{

}

class LikePostInitialState extends LikeState {
  @override
  List<Object?> get props => [];

}

class LikePostSuccessState extends LikeState {
  Post post;

  LikePostSuccessState({required this.post});

  @override
  List<Object?> get props => [post];
}

class UnLikePostSuccessState extends LikeState {
  Post post;

  UnLikePostSuccessState({required this.post});

  @override
  List<Object?> get props => [post];
}

