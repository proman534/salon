import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:startup/base_o.dart'; // Ensure this file correctly handles navigation and layout

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<dynamic> payments = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      final response =
          await http.get(Uri.parse('http://your-backend-url.com/api/payments'));

      if (response.statusCode == 200) {
        setState(() {
          payments = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load payments');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment & Billing",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : hasError
                  ? Center(
                      child: Text("Error loading payments. Try again later."))
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 16.0,
                          columns: [
                            DataColumn(label: Text("Transaction ID")),
                            DataColumn(label: Text("Customer Name")),
                            DataColumn(label: Text("Service")),
                            DataColumn(label: Text("Amount")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Date")),
                          ],
                          rows: payments.map((payment) {
                            return DataRow(cells: [
                              DataCell(
                                  Text(payment["transaction_id"].toString())),
                              DataCell(Text(payment["customer_name"])),
                              DataCell(Text(payment["service"])),
                              DataCell(Text("\$${payment["amount"]}")),
                              DataCell(Text(payment["payment_status"])),
                              DataCell(Text(payment["payment_date"])),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
