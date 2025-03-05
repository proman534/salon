import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalonHomePage extends StatefulWidget {
  @override
  _SalonHomePageState createState() => _SalonHomePageState();
}

class _SalonHomePageState extends State<SalonHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _nearbySalons = [];
  List<dynamic> _searchSuggestions = [];
  List<String> _cities = [
    'New York', 'Los Angeles', 'Chicago',
    'Houston', 'Phoenix', 'Philadelphia'
  ];
  List<Map<String, String>> _categories = [
    {'name': 'HAIR', 'icon': '💇'},
    {'name': 'NAILS', 'icon': '💅'},
    {'name': 'BEARD', 'icon': '👨'},
    {'name': 'FEET', 'icon': '👣'},
    {'name': 'MAKEUP', 'icon': '💄'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchNearbySalons();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchNearbySalons() async {
    try {
      // Request location permissions
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle location permission denied
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      // Call backend API to get nearby salons
      final response = await http.get(
          Uri.parse('/api/nearby_salons?lat=${position.latitude}&lon=${position.longitude}')
      );

      if (response.statusCode == 200) {
        setState(() {
          _nearbySalons = json.decode(response.body)['salons'];
        });
      }
    } catch (e) {
      print('Error fetching nearby salons: $e');
    }
  }

  void _onSearchChanged() {
    // Implement search suggestions logic
    if (_searchController.text.isNotEmpty) {
      _fetchSearchSuggestions(_searchController.text);
    } else {
      setState(() {
        _searchSuggestions = [];
      });
    }
  }

  Future<void> _fetchSearchSuggestions(String query) async {
    try {
      final response = await http.get(
          Uri.parse('/api/search_suggestions?query=$query')
      );

      if (response.statusCode == 200) {
        setState(() {
          _searchSuggestions = json.decode(response.body)['suggestions'];
        });
      }
    } catch (e) {
      print('Error fetching search suggestions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon Finder'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: _fetchNearbySalons,
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar with Suggestions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search salons, services...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Search Suggestions
          if (_searchSuggestions.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _searchSuggestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      label: Text(_searchSuggestions[index]),
                    ),
                  );
                },
              ),
            ),

          // Cities Horizontal Scroll
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to salons in this city
                    },
                    child: Text(_cities[index]),
                  ),
                );
              },
            ),
          ),

          // Categories Horizontal Scroll
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to category details
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(_categories[index]['icon']!, style: TextStyle(fontSize: 30)),
                        ),
                        SizedBox(height: 5),
                        Text(_categories[index]['name']!)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Nearby Salons
          Expanded(
            child: ListView.builder(
              itemCount: _nearbySalons.length,
              itemBuilder: (context, index) {
                var salon = _nearbySalons[index];
                return ListTile(
                  title: Text(salon['name']),
                  subtitle: Text('${salon['distance']} km away'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to salon details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}