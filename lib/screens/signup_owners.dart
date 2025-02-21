import 'package:flutter/material.dart';

class SalonOwnerSignup extends StatefulWidget {
  @override
  _SalonOwnerSignupState createState() => _SalonOwnerSignupState();
}

class _SalonOwnerSignupState extends State<SalonOwnerSignup> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _salonNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Username Field
                    _buildTextField(
                        "Username", _usernameController, Icons.person, false),

                    // First Name Field
                    _buildTextField("First Name", _firstNameController,
                        Icons.person, false),

                    // Last Name Field
                    _buildTextField(
                        "Last Name", _lastNameController, Icons.person, false),

                    // Phone Number Field
                    _buildTextField(
                        "Phone Number", _phoneController, Icons.phone, false),

                    // Email Field
                    _buildTextField(
                        "Email", _emailController, Icons.email, false),

                    // Salon Name Field
                    _buildTextField(
                        "Salon Name", _salonNameController, Icons.store, false),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.people),
                      ),
                      items: ["Male", "Female", "Other"]
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Please select a gender" : null,
                    ),
                    SizedBox(height: 10),

                    // Address Field
                    _buildTextField("Address", _addressController,
                        Icons.location_on, false),

                    // City Field
                    _buildTextField(
                        "City", _cityController, Icons.location_city, false),

                    // State Field
                    _buildTextField(
                        "State", _stateController, Icons.map, false),

                    // Pin Code Field
                    _buildTextField(
                        "Pin Code", _pinCodeController, Icons.pin_drop, false),

                    // Country Field
                    _buildTextField(
                        "Country", _countryController, Icons.public, false),

                    // Password Field
                    _buildTextField(
                        "Password", _passwordController, Icons.lock, true),

                    // Confirm Password Field
                    _buildTextField("Confirm Password",
                        _confirmPasswordController, Icons.lock, true),

                    SizedBox(height: 20),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text("Sign Up", style: TextStyle(fontSize: 18)),
                      ),
                    ),

                    // Already have an account?
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to login
                        },
                        child: Text("Already have an account? Login"),
                      ),
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

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon, bool isPassword) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_passwordVisible,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Passwords do not match"),
              backgroundColor: Colors.red),
        );
        return;
      }

      // Handle signup logic here (API call, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Signup Successful"), backgroundColor: Colors.green),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salonNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _countryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
