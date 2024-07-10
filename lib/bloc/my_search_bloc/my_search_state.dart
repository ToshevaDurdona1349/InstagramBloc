import 'package:ngdemo17/model/member_model.dart';

abstract class MySearchState {}

class MySearchInitialState extends MySearchState {}

class MySearchLoadingState extends MySearchState {}

class MySearchSuccessState extends MySearchState {
  List<Member> items;

  MySearchSuccessState({required this.items});
}

class MySearchFailureState extends MySearchState {
  final String errorMessage;

  MySearchFailureState(this.errorMessage);
}
