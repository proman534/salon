import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final bool isAuthenticated;
  final String username;
  final String title;

  const BaseScreen(
      {super.key,
      required this.child,
      this.isAuthenticated = false,
      this.username = '',
      this.title = 'My App'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('My App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1a1a2e),
        actions: _buildMenuItems(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      _navItem('Home', '/'),
      _navItem('Service', '/service_list'),
      _navItem('Staff', '/staff_list'),
      if (isAuthenticated)
        _navItem('Hello, $username', '/profile')
      else ...[
        _navItem('Login', '/login'),
        _navItem('Signup', '/signup'),
      ],
      if (isAuthenticated) _navItem('Logout', '/logout'),
      IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/notifications');
        },
      ),
    ];
  }

  Widget _navItem(String title, String route) {
    return TextButton(
      onPressed: () {},
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
