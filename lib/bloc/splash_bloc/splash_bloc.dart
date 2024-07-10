import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo17/bloc/splash_bloc/splash_event.dart';
import 'package:ngdemo17/bloc/splash_bloc/splash_state.dart';
import '../../pages/home_page.dart';
import '../../pages/signin_page.dart';
import '../../services/auth_service.dart';
import '../../services/log_service.dart';
import '../../services/notif_service.dart';
import '../../services/prefs_service.dart';
import '../home_bloc/home_bloc.dart';
import '../signin_bloc/signin_bloc.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashWaitEvent>(_onSplashWaitEvent);
  }

  Future<void> _onSplashWaitEvent(SplashWaitEvent event, Emitter<SplashState> emit) async {
    emit(SplashLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashLoadedState());
  }

  callNextPage(BuildContext context) {
    if (AuthService.isLoggedIn()) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => HomeBloc(),
                child: const HomePage(),
              )));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SignInBloc(),
                child: const SignInPage(),
              )));
    }
  }

  initNotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LogService.i('User granted permission');
    } else {
      LogService.e('User declined or has not accepted permission');
    }

    firebaseMessaging.getToken().then((value) async {
      String fcmToken = value.toString();
      Prefs.saveFCM(fcmToken);
      String token = await Prefs.loadFCM();
      LogService.i("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification!.title.toString();
      String body = message.notification!.body.toString();
      LogService.i(title);
      LogService.i(body);
      NotifService().showLocalNotification(title, body);
    });
  }
}
