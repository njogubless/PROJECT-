import 'package:devotion/core/common/loader.dart';
import 'package:devotion/core/error/error_text.dart';
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:devotion/firebase_options.dart';
import 'package:devotion/config/routes/router.dart';
import 'package:devotion/theme/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ StateProvider is still valid in modern Riverpod — no legacy import needed
final sharedPreferencesProvider =
    StateProvider<SharedPreferences?>((ref) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }




  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void fetchDataOnce(User data) async {
    if (userModel == null) {
      userModel = await ref
          .read(authControllerProvider.notifier)
          .getUserData(data.uid)
          .first;
      ref.read(userProvider.notifier).update((state) => userModel);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            // ✅ User is logged in and data is loaded
            if (data != null) {
              fetchDataOnce(data);

              if (userModel != null) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Reflection On Faith',
                  theme: themeState.theme,
                  routerDelegate:
                      RoutemasterDelegate(routesBuilder: (_) => loggedInRoute),
                  routeInformationParser: const RoutemasterParser(),
                );
              }
            }

            // ✅ User is not logged in or userModel not yet loaded
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Reflection On Faith',
              theme: themeState.theme,
              routerDelegate:
                  RoutemasterDelegate(routesBuilder: (_) => loggedOutRoute),
              routeInformationParser: const RoutemasterParser(),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}