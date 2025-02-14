import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:startup/base_o.dart'; // Ensuring navigation integration

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  List<dynamic> categories = [];
  bool isLoading = true;
  bool showModal = false;
  TextEditingController categoryController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://your-backend-url.com/api/categories'),
      );

      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addCategory() async {
    if (categoryController.text.isEmpty) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://your-backend-url.com/api/add_category'),
    );
    request.fields['name'] = categoryController.text;

    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', selectedImage!.path),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Category added successfully")),
        );
        setState(() {
          showModal = false;
          categoryController.clear();
          selectedImage = null;
        });
        fetchCategories();
      } else {
        throw Exception('Failed to add category');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding category")),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                showModal = true;
              });
            },
            child: Text("Add Category"),
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : categories.isEmpty
                  ? Center(child: Text("No categories available"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return Container(
                            width: 150,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (category['image'] != null)
                                  Image.network(
                                    category['image'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                SizedBox(height: 10),
                                Text(
                                  category['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
          if (showModal)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Add New Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: categoryController,
                      decoration: InputDecoration(labelText: "Category Name"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: Text("Pick Image"),
                    ),
                    SizedBox(height: 10),
                    if (selectedImage != null)
                      Image.file(selectedImage!, width: 100, height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: addCategory,
                          child: Text("Save"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showModal = false;
                              categoryController.clear();
                              selectedImage = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
