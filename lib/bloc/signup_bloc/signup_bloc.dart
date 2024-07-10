import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo17/bloc/signup_bloc/signup_event.dart';
import 'package:ngdemo17/bloc/signup_bloc/signup_state.dart';
import '../../model/member_model.dart';
import '../../pages/home_page.dart';
import '../../pages/signin_page.dart';
import '../../services/auth_service.dart';
import '../../services/db_service.dart';
import '../../services/prefs_service.dart';
import '../home_bloc/home_bloc.dart';
import '../signin_bloc/signin_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignedUpEvent>(_onSignedUpEvent);
  }

  Future<void> _onSignedUpEvent(
      SignedUpEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());

    User? firebaseUser = await AuthService.signUpUser(event.context, event.fullname, event.email, event.password);

    if (firebaseUser != null) {
      _saveMemberIdToLocal(firebaseUser);
      _saveMemberToCloud(Member(event.fullname, event.email));
      emit(SignUpSuccessState());
    } else {
      emit(SignUpFailureState("Check information again"));
    }
  }

  _saveMemberIdToLocal(User firebaseUser) async {
    await Prefs.saveUserId(firebaseUser.uid);
  }

  _saveMemberToCloud(Member member) async {
    await DBService.storeMember(member);
  }

  callHomePage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => HomeBloc(),
              child: const HomePage(),
            )));
  }

  callSignInPage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SignInBloc(),
              child: const SignInPage(),
            )));
  }
}
