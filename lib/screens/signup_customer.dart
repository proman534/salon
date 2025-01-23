import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:startup/screens/login_page.dart';

class SignupCustomer extends StatefulWidget {
  @override
  _SignupCustomerState createState() => _SignupCustomerState();
}

class _SignupCustomerState extends State<SignupCustomer> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final addressLineController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final countryController = TextEditingController();

  final PageController _pageController = PageController();
  int currentPage = 0;

  Future<void> registerCustomer() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/register/customer'), // Your Flask API endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'password': passwordController.text,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'phone_number': phoneController.text,
        'gender': genderController.text,
        'date_of_birth': dateOfBirthController.text,
        'address_line': addressLineController.text,
        'city': cityController.text,
        'state': stateController.text,
        'pin_code': pinCodeController.text,
        'country': countryController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer registered successfully!')),
      );
      Navigator.pushNamed(context, '/login_page');
    } else {
      final Map<String, dynamic>? errorResponse = response.body.isNotEmpty
          ? json.decode(response.body)
          : null;
      final String errorMessage = errorResponse?['message'] ?? 'Failed to register customer.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  InputDecoration neumorphicInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Color(0xFFe0e5ec), // Light grey background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text("Customer Signup")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8, // Add shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure column doesn't take up full height
                  children: [
                    Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16), // Space between the login button and the sign-up link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to SignUpPage
                        );
                      },
                      child: const Text('Already have an account, login.'),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        children: [
                          // Step 1: Personal Details
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(labelText:'Username'),
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Please enter username';
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(labelText:'Password'),
                                  validator: (value) {
                                    if (value!.isEmpty) return 'Please enter password';
                                    return null;
                                  },
                                  obscureText: true,
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: firstNameController,
                                  decoration: InputDecoration(labelText: 'First Name'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: lastNameController,
                                  decoration: InputDecoration(labelText:'Last Name'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(labelText:'Email'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(labelText:'Phone Number'),
                                ),
                              ],
                            ),
                          ),
                          // Step 2: Address & Date of Birth
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: genderController,
                                  decoration: InputDecoration(labelText:'Gender'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: dateOfBirthController,
                                  decoration: InputDecoration(labelText:'Date of Birth'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: addressLineController,
                                  decoration: InputDecoration(labelText:'Address Line'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: cityController,
                                  decoration: InputDecoration(labelText:'City'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: stateController,
                                  decoration: InputDecoration(labelText:'State'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: pinCodeController,
                                  decoration: InputDecoration(labelText:'Pin Code'),
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: countryController,
                                  decoration: InputDecoration(labelText:'Country'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage > 0)
                          ElevatedButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text('Back'),
                          ),
                        if (currentPage < 1)
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text('Next'),
                          ),
                        if (currentPage == 1)
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerCustomer();
                              }
                            },
                            child: Text('Register'),
                          ),
                      ],
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
