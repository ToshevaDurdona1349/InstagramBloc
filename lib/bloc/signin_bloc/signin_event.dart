
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignedInEvent extends SignInEvent {
  BuildContext context;
  String email;
  String password;

  SignedInEvent({required this.context,required this.email, required this.password});

  @override
  List<Object> get props => [];
}