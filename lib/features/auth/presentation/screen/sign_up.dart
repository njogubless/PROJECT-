// import 'package:devotion/core/common/sign_in_button.dart';
// import 'package:devotion/features/auth/presentation/screen/login_screen.dart';
// import 'package:devotion/features/auth/presentation/screen/verification_screen.dart';
// import 'package:devotion/theme/theme.dart';
// import 'package:devotion/widget/primary_button.dart';
// import 'package:devotion/widget/signup_form.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> _signUpWithEmail() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         UserCredential userCredential =
//             await _auth.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//         // Store the user in Firestore
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'email': emailController.text.trim(),
//           'phone': phoneController.text.trim(),
//           'uid': userCredential.user!.uid,
//         });

//         // Send email verification
//         await userCredential.user!.sendEmailVerification();

//         // Navigate to email verification page
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const VerificationScreen(
//                     verificationType: '',
//                   )),
//         );
//       } catch (e) {
//         debugPrint('Error during sign up: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error during sign up: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 70,
//             ),
//             Padding(
//               padding: kDefaultPadding,
//               child: Text(
//                 'Create Account',
//                 style: titleText,
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Padding(
//               padding: kDefaultPadding,
//               child: Row(
//                 children: [
//                   Text(
//                     'Already Member ?',
//                     style: subTitle,
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LoginScreen()));
//                     },
//                     child: Text(
//                       'Sign in',
//                       style: textButton.copyWith(
//                         decoration: TextDecoration.underline,
//                         decorationThickness: 1,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10,),
//             const Padding(
//               padding: kDefaultPadding,
//               child: SignupForm(),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Padding(padding: kDefaultPadding,
//             child: PrimaryButton(buttonText: 'Sign Up'),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: kDefaultPadding,
//               child: Text(' or Log In With:',
//               style: subTitle.copyWith(color: kBlackColor),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Padding(
//               padding: kDefaultPadding,
//               child: SignInButton(),
//             ),
//             const SizedBox(
//               height:20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:devotion/core/common/styles/login_Signup_widgets/form_divider.dart';
import 'package:devotion/core/common/styles/login_Signup_widgets/social_button.dart';
import 'package:devotion/core/common/styles/text_strings.dart';
import 'package:devotion/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                children: [
                  const Row(
                    children: [
                      Flexible(
                        child: TextField(
                          expands: false,
                          decoration: InputDecoration(
                              labelText: TTexts.firstName,
                              prefixIcon: Icon(Icons.person_2_rounded)),
                        ),
                      ),
                      SizedBox(width: TSizes.spaceBtwinputFields),
                      Flexible(
                        child: TextField(
                          expands: false,
                          decoration: InputDecoration(
                              labelText: TTexts.lastName,
                              prefixIcon: Icon(Icons.person_2_rounded)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwinputFields),

                  //email
                  const TextField(
                   
                    decoration: InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Icons.email_rounded)),
                  ),
                   const SizedBox(height: TSizes.spaceBtwinputFields),
                  //phone number
                  const TextField(
                    decoration: InputDecoration(
                        labelText: TTexts.phoneNumber,
                        prefixIcon: Icon(Icons.call)),
                  ),
                   const SizedBox(height: TSizes.spaceBtwinputFields),
                  //password
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
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
              TFormDivider(dividerText: TTexts.orSignupWith),
              //social Button
              const TSocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
