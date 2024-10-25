import 'package:devotion/features/admin/presentation/screens/admin_log_in.dart';
import 'package:devotion/features/auth/data/repository/auth_repository.dart';
import 'package:devotion/features/auth/presentation/screen/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context,WidgetRef ref) {
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
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Admin Login'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AdminLoginPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async {
              await authRepository.signOutUser();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));
            },
          ),
        ],
      ),
    );
  }
}
