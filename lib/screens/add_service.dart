import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(SalonDashboard());
}

class SalonDashboard extends StatelessWidget {
  const SalonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _categoryImage = File(pickedFile.path);
      });
    }
  }

  void _addCategory() {
    if (_categoryController.text.isNotEmpty && _categoryImage != null) {
      setState(() {
        categories.add(
            Category(name: _categoryController.text, image: _categoryImage!));
      });
      _categoryController.clear();
      _categoryImage = null;
      Navigator.pop(context);
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
                          decoration:
                              const InputDecoration(labelText: 'Category Name'),
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
                        categories[index].image != null
                            ? Image.file(categories[index].image, height: 100)
                            : Container(),
                        Text(categories[index].name,
                            style: const TextStyle(fontSize: 18)),
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

class Category {
  final String name;
  final File image;

  Category({required this.name, required this.image});
}
