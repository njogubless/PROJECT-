import 'package:devotion/core/common/styles/image_strings.dart';
import 'package:devotion/core/constants/colors.dart';
import 'package:devotion/core/constants/sizes.dart';
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TSocialButton extends ConsumerWidget {
  const TSocialButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
              onPressed: () => authController.signInWithGoogle(context),
              icon: const Image(
                width: TSizes.iconMd,
                height: TSizes.iconMd,
                image: AssetImage(TImages.google),
              )),
        ),
        SizedBox(
          width: TSizes.spaceBtwItems,
        ),
      ],
    );
  }
}
