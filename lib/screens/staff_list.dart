import 'package:flutter/material.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  // Sample Staff Data (Replace with API/Backend Data)
  List<Map<String, dynamic>> staffMembers = [
    {
      "name": "John Doe",
      "photo": "https://via.placeholder.com/120",
      "position": "Manager",
      "email": "john@example.com",
      "phone": "+1234567890"
    },
    {
      "name": "Jane Smith",
      "photo": "https://via.placeholder.com/120",
      "position": "Hair Stylist",
      "email": "jane@example.com",
      "phone": "+0987654321"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Members"),
        backgroundColor: Colors.green[700], // Similar to btn-primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: staffMembers.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 768
                            ? 3
                            : 2, // Responsive grid
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: staffMembers.length,
                      itemBuilder: (context, index) {
                        final staff = staffMembers[index];
                        return StaffCard(
                          name: staff['name'],
                          photoUrl: staff['photo'],
                          position: staff['position'],
                          email: staff['email'],
                          phone: staff['phone'],
                          onEdit: () {
                            // Navigate to edit page (Implement later)
                          },
                          onDelete: () {
                            setState(() {
                              staffMembers.removeAt(index);
                            });
                          },
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No staff members found.",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to add staff page (Implement later)
                            },
                            child: const Text("Add a staff member"),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Add Staff Page (Implement later)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text("Add Staff"),
            ),
          ],
        ),
      ),
    );
  }
}

// Staff Card Widget
class StaffCard extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String position;
  final String email;
  final String phone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StaffCard({
    super.key,
    required this.name,
    required this.photoUrl,
    required this.position,
    required this.email,
    required this.phone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(photoUrl),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Position: $position"),
            Text("Email: $email"),
            Text("Phone: $phone"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onEdit,
                  child:
                      const Text("Edit", style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: onDelete,
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
