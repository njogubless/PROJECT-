import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  final String phoneNumber;
  final String? groupCode;

  WhatsAppService(this.phoneNumber, {this.groupCode});

  Future<void> launchWhatsApp() async {
    late Uri whatsappUrl;

    if (groupCode != null) {
      whatsappUrl = Uri.parse(" htpps:// $groupCode");
    }else{
      whatsappUrl = Uri.parse("htpps:// $phoneNumber");
    }
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw Exception(' could not launch $whatsappUrl');
    }
  }
}
