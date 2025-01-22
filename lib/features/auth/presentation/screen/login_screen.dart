
import 'package:devotion/core/common/styles/image_strings.dart';
import 'package:devotion/core/common/styles/spacing_styles.dart';
import 'package:devotion/core/common/styles/text_strings.dart';
import 'package:devotion/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(TTexts.logInTitle, style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: TSizes.sm,),
                  Text(TTexts.logInSubTitle, style: Theme.of(context).textTheme.bodyMedium,),
                ],
              ),

              Form(
                child:
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                   child: Column(
                                   children: [
                    //email
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Iconsax.direct_right_bold
                        ),labelText: TTexts.email
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwinputFields,),
                    //password
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check_bold),
                        labelText: TTexts.password,
                        suffixIcon: Icon(Iconsax.eye_slash_bold),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwinputFields /2,),
                    ///Remember Me & Forget Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Remember me
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (value){}),
                            const Text(TTexts.rememberMe),
                          ],
                        ),
                        ///Forgot Password
                        TextButton(onPressed: (){}, child: const Text(TTexts.forgetPassword)),
                      ],
                    ),
                    SizedBox(width: double.infinity,
                    // Sign in Button
                    child: ElevatedButton(onPressed: (){}, child: const Text(TTexts.signIn)),),
                    const SizedBox( height: TSizes.spaceBtwItems,), 
                    //Create Account Button
                      SizedBox(width: double.infinity,
                    child: OutlinedButton(onPressed: (){}, child: const Text(TTexts.createAccount)),),
                                   ],
                                 ),
                 ),),

                 ///Divider
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.greenAccent),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: (){}, 
                      icon: const Image(
                        width:TSizes.iconMd,
                        height: TSizes.iconMd,
                        image: AssetImage(TImages.google),)),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems,)
                 ], 
                 ),
                 const SizedBox(height: TSizes.spaceBtwSections,),
            ],
          ),
        ),
      ),
    );
  }
}