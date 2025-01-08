import 'package:devotion/features/admin/presentation/screens/admin_log_in.dart';
import 'package:devotion/features/auth/Repository/auth_repository.dart';
import 'package:devotion/features/auth/presentation/screen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends ConsumerWidget {
  final String userName;
  final String userEmail;
  final String userAvatarUrl; // Use a default avatar image if none provided

  const AppDrawer({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.userAvatarUrl = 'https://via.placeholder.com/150', // Default avatar
  }) : super(key: key);

  Future launchlink(String link) async {
    try {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.read(authRepositoryProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userAvatarUrl),
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Admin Login'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
          ),
          ListTile(
            title: const Text(
              " Reflection On Faith Website",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              launchlink("https:www.hikersafrique.com");
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  await authRepository.signOutUser();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
