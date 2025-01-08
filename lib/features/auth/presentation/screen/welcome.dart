import 'package:devotion/features/auth/presentation/screen/sign_in.dart';
import 'package:devotion/features/auth/presentation/screen/sign_up.dart';
import 'package:devotion/widget/custom_scaffold.dart';
import 'package:devotion/widget/welcome_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                    child: (RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                              text: 'Welcome Back!\n',
                              style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                              text: '\n Enter your personal details',
                              style: TextStyle(
                                fontSize: 20,
                              ))
                        ])))),
              )),
          Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                        child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInPage(),
                    )),
                    Expanded(
                        child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: SignUpPage(),
                    )),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
