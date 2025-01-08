import 'package:devotion/core/constants/colors.dart';
import 'package:devotion/core/constants/helper_functions.dart';
import 'package:flutter/material.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        Flexible(child: Divider(
          color: dark ? TColors.darkGrey : TColors.grey,
           thickness: 0.5,
           indent:60, 
           endIndent: 5,
        )),
        Text(dividerText,style: Theme.of(context).textTheme.labelMedium,),
         Flexible(child: Divider(
          color: dark ? TColors.darkGrey : TColors.grey,
           thickness: 0.5,
           indent:60, 
           endIndent: 5,)),
      ],
    );
  }
}
