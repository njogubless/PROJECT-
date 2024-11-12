import 'package:devotion/core/common/loader.dart';
import 'package:devotion/core/common/sign_in_button.dart';
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:devotion/features/auth/presentation/screen/forget_password_screen.dart';
import 'package:devotion/features/auth/presentation/screen/sign_up.dart';
import 'package:devotion/features/auth/presentation/screen/welcome.dart';
import 'package:devotion/theme/theme.dart';
import 'package:devotion/widget/login_form.dart';
import 'package:devotion/widget/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading ? const Loader() : 
      Padding(
          padding: kDefaultPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  'Reflections On Faith',
                  style: titleText,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      'New to this app?',
                      style: subTitle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        'Sign up',
                        style: textButton.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const LoginForm(),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen()));
                  },
                  child: const Text(
                    ' Forgot Password ?',
                    style: TextStyle(
                        color: kZambeziColor,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationThickness: 1),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()));
                  },
                  child: const PrimaryButton(
                    buttonText: ' Log In',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  ' or Login with:',
                  style: subTitle.copyWith(color: kBlackColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SignInButton()
              ],
            ),
          )),
      // appBar: AppBar(
      //   title: const Text('Refelctions of Faith')
      // ),
    );
  }
}
