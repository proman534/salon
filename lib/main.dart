import 'package:flutter/material.dart';
import 'screens/salon_home_page.dart';
import 'screens/signup_customer.dart';
import 'screens/signup_salon_owner.dart';
import 'screens/login_page.dart';
import 'screens/customer_home_screen.dart';
import 'screens/salon_owner_screen.dart';
import 'screens/profile.dart';
import 'state/auth_provider.dart';
import 'package:provider/provider.dart';

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
          '/': (context) => const SalonHomePage(),
          '/salon_home_page': (context) => const SalonHomePage(),
          '/signup_customer': (context) => const SignupCustomer(),
          '/login_page': (context) => const LoginPage(),
          '/signup_salon_owner': (context) => const SignupSalonOwner(),
          '/customer_home': (context) => const CustomerHomeScreen(),
          '/salon_owner_home': (context) => const SalonOwnerScreen(),
          '/profilePage': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
