import 'package:flutter/material.dart';
import 'package:startup/base.dart';

class BookAppointmentPage extends StatefulWidget {
  final int salonId;
  final int serviceId;
  final String salonName; // Add this if you want to pass the salon name
  final String serviceName; // Add this if you want to pass the service name

  const BookAppointmentPage({
    super.key,
    required this.salonId,
    required this.serviceId,
    required this.salonName,
    required this.serviceName,
  });

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDate = '';
  String _selectedTime = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // A mock function for submitting the appointment. You can integrate API calls here.
  void _submitAppointment() {
    if (_formKey.currentState!.validate()) {
      // Make API call to book the appointment here
      // For example:
      // bookAppointment(widget.salonId, widget.serviceId, _selectedDate, _selectedTime, _nameController.text, _phoneController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Successful!')),
      );
      Navigator.pop(context); // Go back to the previous screen after booking
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Book Appointment',
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Your Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date selection
                const Text('Select Appointment Date:'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    hintText: 'Choose a date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    // Handle date picker
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = '${pickedDate.toLocal()}'.split(' ')[0];
                      });
                    }
                  },
                  controller: TextEditingController(text: _selectedDate),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time selection
                const Text('Select Appointment Time:'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    hintText: 'Choose a time',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    // Handle time picker
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime.format(context);
                      });
                    }
                  },
                  controller: TextEditingController(text: _selectedTime),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitAppointment,
                  child: const Text('Submit Appointment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
