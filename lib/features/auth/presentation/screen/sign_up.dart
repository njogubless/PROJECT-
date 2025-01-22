

import 'package:devotion/core/common/styles/login_Signup_widgets/form_divider.dart';
import 'package:devotion/core/common/styles/login_Signup_widgets/social_button.dart';
import 'package:devotion/core/common/styles/text_strings.dart';
import 'package:devotion/core/constants/sizes.dart';
import 'package:devotion/features/auth/controller/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SignUpController signUpController = ref.watch(signUpControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.signUpTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///FORM
              Form(
                key: signUpController.signupformKey,
                  child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: signUpController.firstName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                          expands: false,
                          decoration: const InputDecoration(
                              labelText: TTexts.firstName,
                              prefixIcon: Icon(Icons.person_2_rounded)),
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwinputFields),
                      Flexible(
                        child: TextFormField(
                          controller: signUpController.lastName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                          expands: false,
                          decoration: const InputDecoration(
                              labelText: TTexts.lastName,
                              prefixIcon: Icon(Icons.person_2_rounded)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwinputFields),

                  //email
                  TextFormField(
                    controller: signUpController.email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Icons.email_rounded)),
                  ),
                   const SizedBox(height: TSizes.spaceBtwinputFields),
                  //phone number
                  TextFormField(
                    controller: signUpController.phoneNumber,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: TTexts.phoneNumber,
                        prefixIcon: Icon(Icons.call)),
                  ),
                   const SizedBox(height: TSizes.spaceBtwinputFields),
                  //password
                  TextFormField(
                    controller: signUpController.password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: Icon(Icons.password_rounded),
                        //suffixIcon: Icon(Icons.)
                        ),
                  ),
                   const SizedBox(height: TSizes.spaceBtwSections),

                   //signupButton
                   SizedBox(width: double.infinity,
                   child: ElevatedButton(onPressed: (){},
                   child: const Text( TTexts.createAccount)),
                   )
                ],
              )),
              //divider
              const TFormDivider(dividerText: TTexts.orSignupWith),
              //social Button
              const TSocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
