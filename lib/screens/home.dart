import 'package:flutter/material.dart';

class BeautySalonHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EBE0),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E2545),
        title: Text(
          "Beauty Salon",
          style:
              TextStyle(color: Color(0xFFE5B299), fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Home", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Services", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Contact", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBKhL0tYLBjOeAYbVYlQmQUyA7j1AwfoAnPQ&s",
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Color(0xFF2E2545).withOpacity(0.6),
            ),
          ),
          // Centered Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Beauty Salon",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE5B299),
                  ),
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
      bottomNavigationBar: Container(
        color: Color(0xFF2E2545),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            "© 2025 Beauty Salon - All Rights Reserved",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
