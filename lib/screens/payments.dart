import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final storage = FlutterSecureStorage();
  final TextEditingController amountController = TextEditingController();
  String selectedMethod = "credit_card";

  Future<void> processPayment() async {
    final token = await storage.read(key: "jwt_token"); // Retrieve JWT Token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not authenticated")),
      );
      return;
    }

    final url = Uri.parse(
        "http://127.0.0.1:5000/api/payments"); // Replace with your backend URL
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "amount": amountController.text,
        "method": selectedMethod,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Payment Successful: ${data['transaction_id']}")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: ${data['error']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Make Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Enter Amount"),
            ),
            DropdownButton<String>(
              value: selectedMethod,
              items: ["credit_card", "paypal", "upi"]
                  .map((method) => DropdownMenuItem(
                      value: method, child: Text(method.toUpperCase())))
                  .toList(),
              onChanged: (value) => setState(() => selectedMethod = value!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: processPayment,
              child: Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
