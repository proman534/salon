import 'package:flutter/material.dart';

import '../base.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock data for the profile
  Map<String, String> user = {
    'username': 'JohnDoe',
    'email': 'john.doe@example.com',
    'phone': '123-456-7890',
    'profilePic': 'https://via.placeholder.com/150', // URL for the profile picture
  };

  // Mock data for appointments
  List<Map<String, String>> appointments = [
    {'salon': 'SS Enterprises', 'service': 'Haircut', 'date': '2023-11-20'},
    {'salon': 'Beauty Bliss', 'service': 'Facial', 'date': '2023-11-15'},
  ];

  // State for toggling between view and edit
  bool isEditing = false;

  // Controllers for edit form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: user['username']);
    emailController = TextEditingController(text: user['email']);
    phoneController = TextEditingController(text: user['phone']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Profile',
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildProfilePicture(),
              const SizedBox(height: 20),
              if (!isEditing)
                buildProfileInfo()
              else
                buildEditForm(),
              const SizedBox(height: 30),
              buildAppointments(),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Picture Section
  Widget buildProfilePicture() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: user['profilePic'] != null
              ? NetworkImage(user['profilePic']!)
              : null,
          backgroundColor: Colors.grey[200],
          child: user['profilePic'] == null
              ? const Icon(Icons.person, size: 50, color: Colors.white)
              : null,
        ),

        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () {
            // Placeholder for editing/changing the profile picture
            changeProfilePicture();
          },
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Change Profile Picture'),
        ),
      ],
    );
  }

  void changeProfilePicture() {
    // Logic for changing the profile picture can go here.
    // For now, we show a snackbar as a placeholder.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change profile picture feature coming soon!')),
    );
  }

  // Profile Information Section
  Widget buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        buildInfoRow('Name', user['username']!),
        buildInfoRow('Email', user['email']!),
        buildInfoRow('Phone Number', user['phone']!),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
            child: const Text('Edit Profile'),
          ),
        ),
      ],
    );
  }

  // Edit Profile Form
  Widget buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        buildTextField('Name', nameController),
        buildTextField('Email', emailController),
        buildTextField('Phone Number', phoneController),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  user['username'] = nameController.text;
                  user['email'] = emailController.text;
                  user['phone'] = phoneController.text;
                  isEditing = false;
                });
              },
              child: const Text('Save Changes'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }

  // Appointment History Section
  Widget buildAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Appointment History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Colors.grey),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Salon', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Service', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...appointments.map((appointment) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appointment['salon']!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appointment['service']!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(appointment['date']!),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        if (appointments.isEmpty)
          const Center(child: Text('No appointments found.')),
      ],
    );
  }

  // Utility Widgets
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
