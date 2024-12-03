import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Custom typedef for error handling
typedef WhatsAppErrorHandler = void Function(String errorMessage);

class WhatsAppService {
  final String phoneNumber;
  final String? groupCode;
  final WhatsAppErrorHandler? onError;

  WhatsAppService({required this.phoneNumber, this.groupCode, this.onError});

  Future<void> launchWhatsApp(BuildContext context) async {
    late Uri whatsappUrl;

    try {
      // Validate phone number format
      if (!_isValidPhoneNumber(phoneNumber)) {
        throw Exception('Invalid phone number format');
      }

      // Determine URL based on group or direct chat
      if (groupCode != null && groupCode!.isNotEmpty) {
        whatsappUrl = Uri.parse("https://chat.whatsapp.com/$groupCode");
      } else {
        whatsappUrl = Uri.parse("https://wa.me/$phoneNumber");
      }

      // Launch WhatsApp
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        onError?.call('could not launch whastapp');
      }
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  // Private method to validate phone number
  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic phone number validation
    final phoneRegex = RegExp(r'^[+]?[0-9]{10,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}

// Enhanced WhatsApp Button with multiple icon options
class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String? groupCode;
  final WhatsAppErrorHandler? onError;

  // Icon Customization
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  // Button Styling
  final ButtonStyle? buttonStyle;
  final Widget? customChild;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Alignment buttonAlignment;

  // Optional text
  final String? buttonText;
  final TextStyle? textStyle;

  const WhatsAppButton({
    super.key,
    required this.phoneNumber,
    this.groupCode,
    this.onError,

    // Icon customization
    this.iconData,
    this.iconColor,
    this.iconSize,

    // Button styling
    this.buttonStyle,
    this.customChild,
    this.width,
    this.height,
    this.decoration,
    this.buttonAlignment = Alignment.center,

    // Text options
    this.buttonText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Determine icon to use
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

  // Build default icon
  Widget _buildDefaultIcon() {
    return Icon(
      iconData ?? FontAwesomeIcons.whatsapp,
      color: iconColor ?? Colors.white,
      size: iconSize ?? 30,
    );
  }

  // Build button content (icon or icon with text)
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

  // Default decoration
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

  // Default button style
  ButtonStyle _buildDefaultButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: const CircleBorder(),
    );
  }
}

// Example Usage Page
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
            // Default WhatsApp Button
            const WhatsAppButton(
              phoneNumber: '+254712345678',
            ),

            const SizedBox(height: 20),

            // Customized WhatsApp Button with custom icon
            const WhatsAppButton(
              phoneNumber: '+254787654321',
              iconData: Icons.message,
              iconColor: Colors.blue,
              width: 80,
              height: 80,
            ),

            const SizedBox(height: 20),

            // WhatsApp Button with text
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

            // WhatsApp Button with error handling
            WhatsAppButton(
              phoneNumber: '+254', // Invalid number to test error handling
              onError: (errorMessage) {
                // Custom error handling
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
