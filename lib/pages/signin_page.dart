
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/signin_bloc/signin_bloc.dart';
import '../bloc/signin_bloc/signin_event.dart';
import '../bloc/signin_bloc/signin_state.dart';
import '../services/utils_service.dart';

class SignInPage extends StatefulWidget {
  static const String id = "signin_page";

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late SignInBloc signInBloc;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn(){
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    signInBloc.add(SignedInEvent(context: context, email: email, password: password));
  }

  @override
  void initState() {
    super.initState();
    signInBloc = context.read<SignInBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInFailureState) {
          Utils.fireToast(state.errorMessage);
        }
        if (state is SignInSuccessState) {
          signInBloc.callHomePage(context);
        }
      },
      builder: (context, state) {
        if (state is SignInLoadingState) {
          return viewOfSignInPage(true);
        }

        return viewOfSignInPage(false);
      },
    );
  }

  Widget viewOfSignInPage(bool isLoading) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(193, 53, 132, 1),
                    Color.fromRGBO(131, 58, 180, 1),
                  ])),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Instagram",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 45,
                              fontFamily: "Billabong"),
                        ),

                        //#email
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 17, color: Colors.white54)),
                          ),
                        ),

                        //#password
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: TextField(
                            controller: passwordController,
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Password",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 17, color: Colors.white54)),
                          ),
                        ),

                        //#signin
                        GestureDetector(
                          onTap: () {
                            _doSignIn();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              height: 50,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(7)),
                              child: const Center(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),

                  //#footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don`t have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            signInBloc.callSignUpPage(context);
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
