import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupSalonOwner extends StatefulWidget {
  @override
  _SignupSalonOwnerState createState() => _SignupSalonOwnerState();
}

class _SignupSalonOwnerState extends State<SignupSalonOwner> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final salonNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final addressLineController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final countryController = TextEditingController();

  Future<void> registerSalonOwner() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/register/salon_owner'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'password': passwordController.text,
        'salon_name': salonNameController.text,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'phone_number': phoneController.text,
        'gender': genderController.text,
        'address_line': addressLineController.text,
        'city': cityController.text,
        'state': stateController.text,
        'pin_code': pinCodeController.text,
        'country': countryController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Salon Owner registered successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register salon owner.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Salon Owner Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter username';
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter password';
                  return null;
                },
                obscureText: true,
              ),
              TextFormField(
                controller: salonNameController,
                decoration: InputDecoration(labelText: 'Salon Name'),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: addressLineController,
                decoration: InputDecoration(labelText: 'Address Line'),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextFormField(
                controller: pinCodeController,
                decoration: InputDecoration(labelText: 'Pin Code'),
              ),
              TextFormField(
                controller: countryController,
                decoration: InputDecoration(labelText: 'Country'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    registerSalonOwner();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
