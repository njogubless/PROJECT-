import 'package:devotion/core/common/loader.dart';
import 'package:devotion/core/error/error_text.dart';
import 'package:devotion/features/auth/controller/auth_controller.dart';
import 'package:devotion/features/auth/data/models/user_models.dart';
import 'package:devotion/firebase_options.dart';
import 'package:devotion/router.dart';
import 'package:devotion/services/bookmark_provider.dart';
import 'package:devotion/theme/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    StateProvider<SharedPreferences?>((ref) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  bool isByPassLogin = true; // Set to true to bypass login for UI testing

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
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (isByPassLogin) {
              // Bypass login, directly go to logged-in route
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Reflection On Faith',
                theme: Pallete.lightModeAppTheme,
                routerDelegate:
                    RoutemasterDelegate(routesBuilder: (_) => loggedInRoute),
                routeInformationParser: const RoutemasterParser(),
              );
            } else {
              if (data != null) {
                fetchDataOnce(data);
                if (userModel != null) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    title: 'Reflection On Faith',
                    theme: Pallete.lightModeAppTheme,
                    routerDelegate: RoutemasterDelegate(
                        routesBuilder: (_) => loggedInRoute),
                    routeInformationParser: const RoutemasterParser(),
                  );
                }
              }

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Reflection On Faith',
                theme: Pallete.lightModeAppTheme,
                routerDelegate:
                    RoutemasterDelegate(routesBuilder: (_) => loggedOutRoute),
                routeInformationParser: const RoutemasterParser(),
              );
            }
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
