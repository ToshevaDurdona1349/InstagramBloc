import 'package:equatable/equatable.dart';

abstract class MySearchEvent extends Equatable {
  const MySearchEvent();
}

class LoadSearchMembersEvent extends MySearchEvent {
  String keyword;

  LoadSearchMembersEvent({required this.keyword});

  @override
  List<Object> get props => [];
}
