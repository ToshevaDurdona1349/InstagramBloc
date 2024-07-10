import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo17/bloc/signin_bloc/signin_event.dart';
import 'package:ngdemo17/bloc/signin_bloc/signin_state.dart';
import '../../pages/home_page.dart';
import '../../pages/signup_page.dart';
import '../../services/auth_service.dart';
import '../../services/prefs_service.dart';
import '../home_bloc/home_bloc.dart';
import '../signup_bloc/signup_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitialState()) {
    on<SignedInEvent>(_onSignedInEvent);
  }

  Future<void> _onSignedInEvent(
      SignedInEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());

    User? firebaseUser = await AuthService.signInUser(
        event.context, event.email, event.password);

    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      emit(SignInSuccessState());
    } else {
      emit(SignInFailureState("Check your email or password"));
    }
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

  callSignUpPage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SignUpBloc(),
              child: const SignUpPage(),
            )));
  }
}
