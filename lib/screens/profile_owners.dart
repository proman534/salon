import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Your Profile",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildUserDetails(),
            const SizedBox(height: 20),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailItem("Username", user.username),
            _buildDetailItem("First Name", user.firstName),
            _buildDetailItem("Last Name", user.lastName),
            _buildDetailItem("Email", user.email),
            _buildDetailItem("Salon Name", user.salonName),
            _buildDetailItem("Phone Number", user.phone),
            _buildDetailItem("Address", user.address),
            _buildDetailItem("City", user.city),
            _buildDetailItem("State", user.state),
            _buildDetailItem("Pin Code", user.pinCode),
            _buildDetailItem("Country", user.country),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton("Edit Profile", Colors.blue, () {
          // Navigate to Edit Profile Page
        }),
        _buildButton("Change Password", Colors.green, () {
          // Navigate to Change Password Page
        }),
        _buildButton("Dashboard", Colors.orange, () {
          // Navigate to Dashboard
        }),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String salonName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String country;

  User({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.salonName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.country,
  });
}
