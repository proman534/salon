import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup/state/auth_provider.dart'; // Import the AuthProvider

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget body;

  const BaseScaffold(
      {required this.title,
      required this.body,
      super.key,
      required AppBar appBar});

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  bool _isSearchActive = false; // Track whether the search bar is active
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: _isSearchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (query) {
                  // You can implement search logic here
                  print('Search query: $query');
                },
              )
            : Text(widget.title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the Drawer
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                if (!_isSearchActive) {
                  _searchController.clear(); // Clear search when closing
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(authProvider.isLoggedIn
                  ? authProvider.user?.name ?? 'User'
                  : 'Guest'),
              accountEmail: Text(authProvider.isLoggedIn
                  ? authProvider.user?.email ?? 'guest@example.com'
                  : 'guest@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  authProvider.isLoggedIn
                      ? authProvider.user?.profilePictureUrl ??
                          "https://via.placeholder.com/150"
                      : "https://via.placeholder.com/150",
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/salon_home_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profilePage');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings_page');
              },
            ),
            ListTile(
              leading:
                  Icon(authProvider.isLoggedIn ? Icons.logout : Icons.login),
              title: Text(authProvider.isLoggedIn ? 'Logout' : 'Login'),
              onTap: () {
                if (authProvider.isLoggedIn) {
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/login_page');
                } else {
                  Navigator.pushReplacementNamed(context, '/login_page');
                }
              },
            ),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
