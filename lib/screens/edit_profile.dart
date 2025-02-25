import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController salonNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://your-backend-url/edit_profile'),
        body: {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'salon_name': salonNameController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'pin_code': pinCodeController.text,
          'country': countryController.text,
          'gender': genderController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Edit Your Profile',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField('First Name', firstNameController),
                  _buildInputField('Last Name', lastNameController),
                  _buildInputField('Email', emailController),
                  _buildInputField('Salon Name', salonNameController),
                  _buildInputField('Phone Number', phoneController),
                  _buildInputField('Address', addressController),
                  _buildInputField('City', cityController),
                  _buildInputField('State', stateController),
                  _buildInputField('Pin Code', pinCodeController),
                  _buildInputField('Country', countryController),
                  _buildInputField('Gender', genderController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Center(child: Text('Save Changes')),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back to Profile',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
            validator: (value) =>
                value!.isEmpty ? 'This field cannot be empty' : null,
          ),
        ],
      ),
    );
  }
}
