// loggedOut route
import 'package:devotion/features/auth/presentation/screen/home_screen.dart';
import 'package:devotion/features/auth/presentation/screen/login_screen.dart';
import 'package:devotion/features/auth/presentation/screen/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final LoggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: SignUpScreen())}); 

// loggedIn route

final LoggedInRoute =
    RouteMap(routes: {'/': (_) => MaterialPage(child: HomeScreen())}); 