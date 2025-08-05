import 'package:devotion/core/common/navigation/main_layout.dart';
import 'package:devotion/core/common/styles/image_strings.dart';
import 'package:devotion/core/common/styles/spacing_styles.dart';
import 'package:devotion/core/common/styles/text_strings.dart';
import 'package:devotion/core/constants/sizes.dart';
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:devotion/features/auth/controller/auth_preferences.dart';
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:devotion/features/auth/presentation/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final savedCredentials = await AuthPreferences.getSavedCredentials();
    setState(() {
      rememberMe = savedCredentials['rememberMe'];
      if (rememberMe) {
        emailController.text = savedCredentials['email'];
        passwordController.text = savedCredentials['password'];
      }
    });
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link'),
            const SizedBox(height: TSizes.spaceBtwinputFields),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: TTexts.email,
                prefixIcon: Icon(Iconsax.direct_right_bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(authControllerProvider.notifier)
                  .resetPassword(context, emailController.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authControllerProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TTexts.logInTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  Text(
                    TTexts.logInSubTitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: TSizes.spaceBtwSections),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter a valid email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right_bold),
                          labelText: TTexts.email,
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwinputFields),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.password_check_bold),
                          labelText: TTexts.password,
                          suffixIcon: Icon(Iconsax.eye_slash_bold),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwinputFields / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                              const Text(TTexts.rememberMe),
                            ],
                          ),
                          TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: const Text(TTexts.forgetPassword),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (formKey.currentState!.validate()) {
                              await AuthPreferences.saveLoginCredentials(
                                  email, password, rememberMe);

                              ref
                                  .read(authControllerProvider.notifier)
                                  .signInWithEmailAndPassword(
                                      context, email, password)
                                  .then((_) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainLayout()));
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          _getErrorMessage(error.toString()))),
                                );
                              });
                            }
                          },
                          child: const Text(TTexts.logInTitle),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ));
                            },
                            child: const Text(
                              TTexts.createAccount,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle(context);
                      },
                      icon: const Image(
                        width: TSizes.iconMd,
                        height: TSizes.iconMd,
                        image: AssetImage(TImages.google),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

String _getErrorMessage(String error) {
  if (error.contains('user-not-found')) {
    return 'No user found with this email';
  } else if (error.contains('wrong-password')) {
    return 'Wrong password provided';
  } else if (error.contains('invalid-email')) {
    return 'Invalid email address';
  }
  return 'An error occurred during sign in';
}
