import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Appointment> appointments;

  const NotificationsPage({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Notifications"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Appointment Notifications",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue),
                  headingTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  columns: const [
                    DataColumn(label: Text("Person Name")),
                    DataColumn(label: Text("Time Slot")),
                    DataColumn(label: Text("Category")),
                    DataColumn(label: Text("Service Name")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: appointments.map((appointment) {
                    return DataRow(cells: [
                      DataCell(Text(appointment.personName)),
                      DataCell(Text(appointment.timeSlot)),
                      DataCell(Text(appointment.category)),
                      DataCell(Text(appointment.serviceName)),
                      DataCell(
                        Text(
                          appointment.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(appointment.status),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

class Appointment {
  final String personName;
  final String timeSlot;
  final String category;
  final String serviceName;
  final String status;

  Appointment({
    required this.personName,
    required this.timeSlot,
    required this.category,
    required this.serviceName,
    required this.status,
  });
}
