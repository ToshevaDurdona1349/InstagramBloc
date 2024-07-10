

import 'package:equatable/equatable.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();
}

class LoadProfileMemberEvent extends MyProfileEvent {
  @override
  List<Object> get props => [];
}