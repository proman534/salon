import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditServicePage extends StatefulWidget {
  @override
  _EditServicePageState createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController timeRequiredController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission (e.g., API call)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Service")),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Edit Service",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),

                // Service Name
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Service Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter a service name" : null,
                ),

                SizedBox(height: 10),

                // Service Image
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Pick Image"),
                ),
                _image != null ? Image.file(_image!, height: 100) : Container(),

                SizedBox(height: 10),

                // Time Required
                TextFormField(
                  controller: timeRequiredController,
                  decoration: InputDecoration(labelText: "Time Required"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter time required" : null,
                ),

                SizedBox(height: 10),

                // Description
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 4,
                  validator: (value) =>
                      value!.isEmpty ? "Enter a description" : null,
                ),

                SizedBox(height: 10),

                // Price
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter a price" : null,
                ),

                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Update Service"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
