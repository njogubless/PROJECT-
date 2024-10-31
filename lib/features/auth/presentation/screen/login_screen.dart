import 'package:devotion/theme/theme.dart';
import 'package:devotion/widget/login_form.dart';
import 'package:devotion/widget/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: kDefaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120,),
          Text('Reflections On Faith',
          style: titleText,),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text('New to this app?',style: subTitle,),
              const SizedBox(width: 5,),
              Text('Sign up', style: textButton.copyWith(
                decoration: TextDecoration.underline,decorationThickness: 1,
              ),)
            ],
          ),
          const SizedBox(height: 10,),
          const LoginForm(),
          SizedBox( height: 20,),
          Text(' Forgot Password ?', 
          style:TextStyle(
            color: kZambeziColor,
            fontSize: 14,
            decoration: TextDecoration.underline,
            decorationThickness: 1),
            ),
            SizedBox(height:20,),
            PrimaryButton(
              buttonText: ' Log In',
            ),
            SizedBox(height: 20,),
            Text(' or Login with:',
            style: subTitle.copyWith(color: kBlackColor),
            ),
            SizedBox(height: 20,),
            
        ],
      )),
      // appBar: AppBar(
      //   title: const Text('Refelctions of Faith')
      // ),
    );
  }
}
