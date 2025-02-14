import 'package:flutter/material.dart';
import 'package:startup/base_o.dart';

class AddPaymentScreen extends StatefulWidget {
  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission (API call or database logic)
      print("Payment added: \${_amountController.text}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment successfully added!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Add New Payment",
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add New Payment",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Amount"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an amount";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: "Description"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a description";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitPayment,
                    child: Text("Add Payment"),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/payment_history");
                    },
                    child: Text("Back to Payment History"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
