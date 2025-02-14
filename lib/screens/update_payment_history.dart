import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:startup/base_o.dart'; // Ensure this file correctly handles navigation and layout

class UpdatePaymentStatusScreen extends StatefulWidget {
  final String transactionId;

  const UpdatePaymentStatusScreen({super.key, required this.transactionId});

  @override
  _UpdatePaymentStatusScreenState createState() =>
      _UpdatePaymentStatusScreenState();
}

class _UpdatePaymentStatusScreenState extends State<UpdatePaymentStatusScreen> {
  Map<String, dynamic>? payment;
  bool isLoading = true;
  bool hasError = false;
  String selectedStatus = "Pending"; // Default value

  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  Future<void> fetchPaymentDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://your-backend-url.com/api/payment/${widget.transactionId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          payment = json.decode(response.body);
          selectedStatus = payment?['payment_status'] ?? "Pending";
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load payment details');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> updatePaymentStatus() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://your-backend-url.com/api/payment/${widget.transactionId}/update'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"payment_status": selectedStatus}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment status updated successfully")),
        );
        Navigator.pop(context); // Go back to payment history
      } else {
        throw Exception('Failed to update payment status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error updating payment status")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text("Error loading payment details"))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Payment Status for ${payment?['transaction_id']}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: ["Pending", "Completed", "Failed"].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Payment Status",
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updatePaymentStatus,
                      child: const Text("Update Status"),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Back to Payment History"),
                    ),
                  ],
                ),
    );
  }
}
