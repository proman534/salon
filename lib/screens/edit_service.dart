import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate()) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://your-backend-url/edit_service'),
      );
      request.fields['name'] = nameController.text;
      request.fields['time_required'] = timeRequiredController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['price'] = priceController.text;
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update service.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Service'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Edit Service',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildInputField('Service Name', nameController),
                  _buildInputField('Time Required', timeRequiredController),
                  _buildInputField('Description', descriptionController,
                      isMultiline: true),
                  _buildInputField('Price', priceController,
                      inputType: TextInputType.number),
                  SizedBox(height: 15),
                  Text('Service Image',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 5),
                  _image == null
                      ? Text('No image selected')
                      : Image.file(_image!, height: 100),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Choose Image',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Center(child: Text('Update Service')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isMultiline = false,
      TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: inputType,
            maxLines: isMultiline ? 4 : 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
            validator: (value) =>
                value!.isEmpty ? 'This field cannot be empty' : null,
          ),
        ],
      ),
    );
  }
}
