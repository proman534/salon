import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Service> services = [];
  bool isLoading = true;
  String baseUrl =
      "http://127.0.0.1:5000/"; // Replace with your actual backend URL

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/services"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          services = data.map((item) => Service.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load services");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching services: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2545),
        title: const Text(
          "Beauty Salon",
          style:
              TextStyle(color: Color(0xFFE5B299), fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  "$baseUrl/images/salon_background.jpg", // Fetch background from backend
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey), // Handle errors
                ),
              ),
              Positioned.fill(
                child:
                    Container(color: const Color(0xFF2E2545).withOpacity(0.6)),
              ),
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Beauty Salon",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE5B299)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Experience luxury, elegance, and style in every visit.",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Services List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Image.network(
                            "$baseUrl/${service.imageName}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                          ),
                          title: Text(service.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF2E2545),
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text(
            "© 2025 Beauty Salon - All Rights Reserved",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Service Model
class Service {
  final int id;
  final String imageName;
  final String name;

  Service({required this.id, required this.imageName, required this.name});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      imageName: json['image_name'],
      name: json['name'],
    );
  }
}
