import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


typedef WhatsAppErrorHandler = void Function(String errorMessage);

class WhatsAppService {
  final String phoneNumber;
  final String? groupCode;
  final WhatsAppErrorHandler? onError;

  WhatsAppService({required this.phoneNumber, this.groupCode, this.onError});

  Future<void> launchWhatsApp(BuildContext context) async {
    late Uri whatsappUrl;

    try {

      if (!_isValidPhoneNumber(phoneNumber)) {
        throw Exception('Invalid phone number format');
      }

      
      if (groupCode != null && groupCode!.isNotEmpty) {
        whatsappUrl = Uri.parse("https://chat.whatsapp.com/$groupCode");
      } else {
        whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");
      }

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        onError?.call('could not launch whastapp');
      }
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  
  bool _isValidPhoneNumber(String phoneNumber) {

    final phoneRegex = RegExp(r'^[+]?[0-9]{10,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String? groupCode;
  final WhatsAppErrorHandler? onError;

  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  final ButtonStyle? buttonStyle;
  final Widget? customChild;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Alignment buttonAlignment;

  
  final String? buttonText;
  final TextStyle? textStyle;

  const WhatsAppButton({
    super.key,
    required this.phoneNumber,
    this.groupCode,
    this.onError,

  
    this.iconData,
    this.iconColor,
    this.iconSize,

    this.buttonStyle,
    this.customChild,
    this.width,
    this.height,
    this.decoration,
    this.buttonAlignment = Alignment.center,

    this.buttonText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget iconWidget = customChild ?? _buildDefaultIcon();

    return Container(
      width: width ?? 60,
      height: height ?? 60,
      alignment: buttonAlignment,
      decoration: decoration ?? _buildDefaultDecoration(),
      child: ElevatedButton(
        style: buttonStyle ?? _buildDefaultButtonStyle(),
        onPressed: () {
          final whatsAppService = WhatsAppService(
            phoneNumber: phoneNumber,
            groupCode: groupCode,
            onError: onError,
          );
          whatsAppService.launchWhatsApp(context);
        },
        child: _buildButtonContent(iconWidget),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(
      iconData ?? FontAwesomeIcons.whatsapp,
      color: iconColor ?? Colors.white,
      size: iconSize ?? 30,
    );
  }

  Widget _buildButtonContent(Widget iconWidget) {
    if (buttonText == null) return iconWidget;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconWidget,
        const SizedBox(width: 8),
        Text(
          buttonText!,
          style: textStyle ?? const TextStyle(color: Colors.white),
        )
      ],
    );
  }


  BoxDecoration _buildDefaultDecoration() {
    return const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ]);
  }

  ButtonStyle _buildDefaultButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: const CircleBorder(),
    );
  }
}

class WhatsAppIntegrationPage extends StatelessWidget {
  const WhatsAppIntegrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
   
            const WhatsAppButton(
              phoneNumber: '+254712345678',
            ),

            const SizedBox(height: 20),

            const WhatsAppButton(
              phoneNumber: '+254787654321',
              iconData: Icons.message,
              iconColor: Colors.blue,
              width: 80,
              height: 80,
            ),

            const SizedBox(height: 20),

 
            WhatsAppButton(
              phoneNumber: '+254723456789',
              buttonText: 'Chat Now',
              iconColor: Colors.white,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 20),

            WhatsAppButton(
              phoneNumber: '+254', 
              onError: (errorMessage) {
             
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('WhatsApp Error'),
                    content: Text(errorMessage),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
