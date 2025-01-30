import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:devotion/core/common/styles/login_Signup_widgets/form_divider.dart';
import 'package:devotion/core/common/styles/login_Signup_widgets/social_button.dart';
import 'package:devotion/core/common/styles/text_strings.dart';
import 'package:devotion/core/constants/sizes.dart';
import 'package:devotion/features/auth/controller/sign_up_controller.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpController = ref.watch(signUpControllerProvider.notifier);
    final signUpState = ref.watch(signUpControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.signUpTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form Section
              Form(
                key: signUpController.signupformKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: _buildTextField(
                            controller: signUpController.firstName,
                            label: TTexts.firstName,
                            icon: Icons.person_2_rounded,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your first name'
                                : null,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwinputFields),
                        Flexible(
                          child: _buildTextField(
                            controller: signUpController.lastName,
                            label: TTexts.lastName,
                            icon: Icons.person_2_rounded,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your last name'
                                : null,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwinputFields),
                    _buildTextField(
                      controller: signUpController.email,
                      label: TTexts.email,
                      icon: Icons.email_rounded,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your email'
                          : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwinputFields),
                    _buildTextField(
                      controller: signUpController.phoneNumber,
                      label: TTexts.phoneNumber,
                      icon: Icons.call,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your phone number'
                          : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwinputFields),
                    _buildTextField(
                      controller: signUpController.password,
                      label: TTexts.password,
                      icon: Icons.password_rounded,
                      obscureText: true,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your password'
                          : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Sign-Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUpState.isLoading
                            ? null
                            : () => signUpController.signUp(context),
                        child: signUpState.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(TTexts.createAccount),
                      ),
                    ),
                  ],
                ),
              ),

              const TFormDivider(dividerText: TTexts.orSignupWith),
              const TSocialButton(),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Sign-In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account?"),
                  TextButton(
                    onPressed: () =>
                        Routemaster.of(context).replace('/login'),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Text Field Builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
