import 'dart:io';
import 'package:devotion/features/admin/presentation/screens/admin_log_in.dart';
import 'package:devotion/features/auth/Repository/auth_repository.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);



   Future launchlink(String link) async {
    try {
      await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _uploadProfilePicture(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Upload image to Firebase Storage
          final storageRef = FirebaseStorage.instance
              .ref('user_avatars/${user.uid}.jpg');
          await storageRef.putFile(imageFile);

          // Get download URL
          final downloadUrl = await storageRef.getDownloadURL();

          // Update Firestore with the new profile picture URL
          await FirebaseFirestore.instance
              .collection(FirebaseConstants.usersCollection)
              .doc(user.uid)
              .update({'avatarUrl': downloadUrl});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.read(authRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Loading...'),
            accountEmail: Text(user?.email ?? 'Loading...'),
            currentAccountPicture: GestureDetector(
              onTap: () async {
                await _uploadProfilePicture(context);
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage('assets/images/wheel.png')
                            as ImageProvider,
                    radius: 30,
                  ),
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Admin Login"),
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
              launchlink("https://andrewcphiri.com/");
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  await authRepository.signOutUser();
                  if (context.mounted) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
