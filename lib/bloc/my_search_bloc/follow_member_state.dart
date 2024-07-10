import 'package:equatable/equatable.dart';
import 'package:ngdemo17/model/member_model.dart';


abstract class FollowState extends Equatable {}

class FollowMemberInitialState extends FollowState {
  @override
  List<Object?> get props => [];
}

class FollowMemberSuccessState extends FollowState {
  Member member;

  FollowMemberSuccessState({required this.member});

  @override
  List<Object?> get props => [member];
}

class UnFollowMemberSuccessState extends FollowState {
  Member member;

  UnFollowMemberSuccessState({required this.member});

  @override
  List<Object?> get props => [member];
}
