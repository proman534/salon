import 'package:flutter/material.dart';
import 'package:startup/base.dart'; // Import your BaseScaffold

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startup/screens/salon_details.dart';

import 'book_appointment.dart';

class SalonHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SalonHomePage> {
  List<dynamic> services = []; // Initialize services as an empty list
  List<dynamic> salons = []; // Initialize salons as an empty list
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
    fetchSalons();
  }

  // Fetch services data from the backend
  Future<void> fetchServices() async {
    const url = 'http://10.0.2.2:5000/api/services'; // Replace with your Flask API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Ensure that services is assigned only if it's not null
          services = data['services'] != null ? List.from(data['services']) : [];
          print('Services: $services');  // Debugging print
        });
      } else {
        print('Error fetching services: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fetch salons data from the backend
  Future<void> fetchSalons() async {
    const url = 'http://10.0.2.2:5000/api/salons'; // Replace with your Flask API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Ensure that salons is assigned only if it's not null
          salons = data['salons'] != null ? List.from(data['salons']) : [];
          isLoading = false;  // Update loading status once data is fetched
          print('Salons: $salons');  // Debugging print
        });
      } else {
        print('Error fetching salons: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Home',
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nearby Salons Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Nearby Salons',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Ensure that salons list is not empty
              if (salons.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: salons.length,
                  itemBuilder: (context, index) {
                    final salon = salons[index];
                    return SalonCard(
                      salon:salon,
                      name: salon['name'],
                      imageUrl: 'lib/assets/images/${salon['image_name']}',
                    );
                  },
                ),
              // If salons are empty, display a message
              if (salons.isEmpty)
                Center(child: Text("No salons available")),
              // Our Services Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Our Services',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Ensure that services list is not empty
              if (services.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceCard(
                      name: service['name'],
                      imageUrl: 'lib/assets/images/${service['image_name']}',
                    );
                  },
                ),
              // If services are empty, display a message
              if (services.isEmpty)
                Center(child: Text("No services available")),
            ],
          ),
        ),
      ),
    );
  }
}

class SalonCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Map<String, dynamic> salon; // Add the salon parameter

  const SalonCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.salon, // Initialize the salon parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
              context,
                MaterialPageRoute(
                  builder: (context) => ExploreSalonPage(
                    salon: {
                    'id': salon['id'] ?? '', // Default to an empty string if null
                    'name': salon['name'] ?? 'Unknown Salon',
                    'address': salon['address'] ?? 'No address available',
                    'image_name': salon['image_name'] ?? 'default_image.jpg', // Replace with your placeholder image
                    'latitude': salon['latitude'] ?? '0.0',
                    'longitude': salon['longitude'] ?? '0.0',
                    'rating': salon['rating'] ?? 0.0, // Default to 0 rating
                    },
                    // services: salon['services'] ?? [], // Default to an empty list
                  ),
                ),
              );
            },
            child: Text('Explore Salon'),
          ),
        ],
      ),
    );
  }
}


class ServiceCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ServiceCard({
    Key? key,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  get salon => null;

  get service => null;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          ElevatedButton(
            onPressed: () {
              // Handle "Book Service" action here
            },
            child: Text('Book Service'),
          ),
        ],
      ),
    );
  }
}
