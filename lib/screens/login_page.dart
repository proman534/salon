import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:startup/screens/salon_home_page.dart';
import 'package:startup/screens/signup_salon_owner.dart';
import 'dart:convert';
import '../state/auth_provider.dart';
import 'customer_home_screen.dart';
import 'signup_customer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final inputController =
      TextEditingController(); // Single field for username, email, or phone
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'identifier':
              inputController.text.trim(), // Remove unnecessary spaces
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String token = responseData['token'];
        // User user = User(
        //   name: responseData['user']['name'],
        //   email: responseData['user']['email'],
        //   profilePictureUrl: 'https://example.com/profile.jpg', // Replace with actual data
        // );

        // Save token and user to state
        // await Provider.of<AuthProvider>(context, listen: false).login(token, user);

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SalonHomePage()),
        );
      } else {
        final error = json.decode(response.body)['error'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8, // Adds shadow for the card effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center content vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center content horizontally
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // Space between the title and the text fields
                    TextFormField(
                      controller: inputController,
                      decoration: const InputDecoration(
                        labelText: 'Username, Email, or Phone',
                        hintText: 'Enter your username, email, or phone',
                      ),
                    ),
                    const SizedBox(height: 16), // Space between the fields
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(
                        height:
                            16), // Space between input fields and the button
                    ElevatedButton(
                      onPressed: loginUser,
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                        height:
                            16), // Space between the login button and the sign-up link
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sign Up'),
                              content: const Text(
                                  'Choose the type of account you want to create:'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupCustomer()), // Navigate to the customer signup page
                                    );
                                  },
                                  child: const Text('Sign up as a Customer'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupSalonOwner()), // Navigate to the owner signup page
                                    );
                                  },
                                  child: const Text('Sign up as an Owner'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Don\'t have an account? Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
