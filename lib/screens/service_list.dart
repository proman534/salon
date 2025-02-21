import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(ManageServicesApp());
}

class ManageServicesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManageServicesPage(),
    );
  }
}

class ManageServicesPage extends StatefulWidget {
  @override
  _ManageServicesPageState createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  List<Category> categories = [];

  void _showCategoryDialog() {
    TextEditingController categoryController = TextEditingController();
    XFile? imageFile;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      imageFile = pickedFile;
                    });
                  }
                },
                child: Text("Upload Image"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    categories.add(Category(
                        categoryController.text, imageFile?.path ?? "", []));
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showServiceDialog(Category category) {
    TextEditingController nameController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController costController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Service to ${category.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Service Name'),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time (e.g., 30 mins)'),
              ),
              TextField(
                controller: costController,
                decoration: InputDecoration(labelText: 'Cost (e.g., \$50)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    timeController.text.isNotEmpty &&
                    costController.text.isNotEmpty) {
                  setState(() {
                    category.services.add(Service(
                      nameController.text,
                      timeController.text,
                      costController.text,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(Category category) {
    setState(() {
      categories.remove(category);
    });
  }

  void _deleteService(Category category, Service service) {
    setState(() {
      category.services.remove(service);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Manage Services"), backgroundColor: Colors.blue),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showCategoryDialog,
              child: Text("Add Category"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Category category = categories[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              if (category.imagePath.isNotEmpty)
                                Image.file(File(category.imagePath),
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategory(category),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(category.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () => _showServiceDialog(category),
                            child: Text("Add Service"),
                          ),
                          ...category.services.map((service) => ListTile(
                                title: Text(
                                    "${service.name} - ${service.time} - ${service.cost}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () =>
                                      _deleteService(category, service),
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
  String imagePath;
  List<Service> services;

  Category(this.name, this.imagePath, this.services);
}

class Service {
  String name;
  String time;
  String cost;

  Service(this.name, this.time, this.cost);
}
