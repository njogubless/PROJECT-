import 'package:devotion/features/Profile/Domain/Providers.dart';
import 'package:devotion/features/Profile/Presentation/widgets/edit_profile.dart';
import 'package:devotion/features/Profile/Presentation/widgets/profile_header.dart';
import 'package:devotion/features/Profile/Presentation/widgets/profile_stats.dart';
import 'package:devotion/features/Profile/Presentation/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _showEditProfileDialog(BuildContext context, dynamic profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return EditProfileSheet(profile: profile);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(userProfileProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final profile = profileAsyncValue.value;
              if (profile != null) {
                _showEditProfileDialog(context, profile);
              }
            },
          ),
        ],
      ),
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Please sign in to view your profile'));
          }
          
          return Column(
            children: [
              ProfileHeader(profile: profile),
              ProfileStats(profile: profile),
              const Expanded(child: ProfileTabs()),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading profile: $error'),
        ),
      ),
    );
  }
}