import 'package:flutter/material.dart';
import 'package:startup/screens/home.dart';
import 'screens/salon_home_page.dart';
import 'screens/signup_customer.dart';
import 'screens/signup_salon_owner.dart';
import 'screens/customer_home_screen.dart';
import 'screens/salon_owner_screen.dart';
import 'screens/profile.dart';
import 'state/auth_provider.dart';
import 'package:provider/provider.dart';
import 'screens/salon_owner_login_page.dart';
import 'screens/customer_login_page.dart';
import 'screens/app_launch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Salon App',
        initialRoute: '/',
        routes: {
          '/': (context) => CustomerHomePage(),
          '/signup_customer': (context) => const CustomerSignupPage(),
          '/signup_salon_owner': (context) => const SalonOwnerSignupScreen(),
          '/customer_home': (context) => CustomerHomePage(),
          '/salon_owner_home': (context) => const SalonOwnerScreen(),
          '/profilePage': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
