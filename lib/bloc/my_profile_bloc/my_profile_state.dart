import 'package:ngdemo17/model/member_model.dart';


abstract class MyProfileState {}

class MyProfileInitialState extends MyProfileState {}

class MyProfileLoadingState extends MyProfileState {}

class MyProfileLoadMemberState extends MyProfileState {
  Member member;

  MyProfileLoadMemberState({required this.member});
}

class MyProfileFailureState extends MyProfileState {
  final String errorMessage;

  MyProfileFailureState(this.errorMessage);
}