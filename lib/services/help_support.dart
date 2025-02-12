import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@yourdomain.com',
      queryParameters: {
        'subject': 'Support Request',
      },
    );
    
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.contact_support, color: Colors.blue),
                  title: const Text('Contact Support'),
                  subtitle: const Text('Get help from our support team'),
                  onTap: _launchEmail,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('How do I reset my password?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'To reset your password, go to the login page and click on "Forgot Password". '
                      'Follow the instructions sent to your email to create a new password.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('How do I update my profile?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Go to Settings > Account Settings > Edit Profile to update your information. '
                      'Make your changes and click Save to confirm.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('How do I enable notifications?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Go to Settings > App Settings and toggle the "Enable Notifications" switch. '
                      'You may need to allow notifications in your device settings as well.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: const Text('pnjogubless@gmail.com'),
                        onTap: _launchEmail,
                      ),
                      const ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('Support Hours'),
                        subtitle: Text('Monday - Friday: 9:00 AM - 5:00 PM'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _launchEmail,
                  icon: const Icon(Icons.email),
                  label: const Text('Send Support Email'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}