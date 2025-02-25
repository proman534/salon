import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(SalonDashboard());
}

class SalonDashboard extends StatelessWidget {
  const SalonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  List<Category> categories = [
    Category(name: "Haircuts", services: [
      Service(name: "Basic Haircut", price: "₹300", time: "30 mins"),
      Service(name: "Advanced Haircut", price: "₹500", time: "45 mins")
    ]),
    Category(name: "Facials", services: [
      Service(name: "Basic Facial", price: "₹400", time: "40 mins"),
      Service(name: "Gold Facial", price: "₹800", time: "60 mins")
    ]),
  ];

  File? _selectedImage;

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _addCategory(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: 'Category Name')),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  categories.add(Category(name: nameController.text));
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addService(BuildContext context, Category category) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Service Name')),
              TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price')),
              TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  category.services.add(Service(
                    name: nameController.text,
                    price: priceController.text,
                    time: timeController.text,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  void _deleteService(Category category, int index) {
    setState(() {
      category.services.removeAt(index);
    });
  }

  void _toggleServiceStatus(Service service) {
    setState(() {
      service.enabled = !service.enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salon Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _addCategory(context),
              child: const Text('+ Add New Category'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.green),
                                    onPressed: () =>
                                        _addService(context, category),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteCategory(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_selectedImage != null)
                            Image.file(_selectedImage!,
                                width: 100, height: 100, fit: BoxFit.cover),
                          const SizedBox(height: 10),
                          ...category.services.map((service) => ListTile(
                                title: Text(service.name),
                                subtitle:
                                    Text('${service.price} - ${service.time}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Switch(
                                      value: service.enabled,
                                      onChanged: (value) =>
                                          _toggleServiceStatus(service),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _deleteService(category,
                                          category.services.indexOf(service)),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
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
  String name;
  List<Service> services;
  Category({required this.name, this.services = const []});
}

class Service {
  String name;
  String price;
  String time;
  bool enabled;
  Service(
      {required this.name,
      required this.price,
      required this.time,
      this.enabled = true});
}
