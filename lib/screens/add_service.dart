import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

void main() {
  runApp(const SalonDashboard());
}

class SalonDashboard extends StatelessWidget {
  const SalonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Category> categories = [];
  final TextEditingController _categoryController = TextEditingController();
  File? _categoryImage;
  final picker = ImagePicker();
  static const String baseUrl = "http://127.0.0.1:5000"; // Flask API URL

  // ✅ Pick Image from Gallery
  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _categoryImage = File(pickedFile.path);
      });
    }
  }

  // ✅ Add Category via API
  Future<void> _addCategory() async {
    if (_categoryController.text.isNotEmpty && _categoryImage != null) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/categories'));

        // Add category name
        request.fields['name'] = _categoryController.text;

        // Attach image
        var stream = http.ByteStream(_categoryImage!.openRead());
        var length = await _categoryImage!.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(_categoryImage!.path),
          contentType: MediaType.parse(lookupMimeType(_categoryImage!.path) ?? 'image/jpeg'),
        );

        request.files.add(multipartFile);

        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        if (response.statusCode == 201) {
          setState(() {
            categories.add(Category(
              name: jsonResponse['message'],
              imageUrl: '$baseUrl' + jsonResponse['image_url'],
            ));
          });

          _categoryController.clear();
          _categoryImage = null;
          Navigator.pop(context);
        } else {
          print('Error: ${response.reasonPhrase}');
        }
      } catch (e) {
        print("Exception while adding category: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Dashboard'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Profile', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Add New Category'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _categoryController,
                          decoration: const InputDecoration(labelText: 'Category Name'),
                        ),
                        const SizedBox(height: 10),
                        _categoryImage == null
                            ? const Text('No image selected')
                            : Image.file(_categoryImage!, height: 100),
                        TextButton(
                          onPressed: _pickImage,
                          child: const Text('Pick Image'),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: _addCategory,
                        child: const Text('Add Category'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Add Category'),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        categories[index].imageUrl.isNotEmpty
                            ? Image.network(categories[index].imageUrl, height: 100)
                            : Container(),
                        Text(categories[index].name, style: const TextStyle(fontSize: 18)),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Add Service'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Updated Category Model
class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}
