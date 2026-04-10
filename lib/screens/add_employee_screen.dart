
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/database_service.dart';
import '../models/employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _employeeName;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addEmployee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? imagePath;
      if (_image != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await _image!.copy('${appDir.path}/$fileName');
        imagePath = savedImage.path;
      }

      final newEmployee = Employee(name: _employeeName!, photoPath: imagePath);
      final db = await DatabaseService.instance.database;
      await db.insert('employees', newEmployee.toMap());
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Employee Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _employeeName = value;
                },
              ),
              const SizedBox(height: 20),
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Take Photo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addEmployee,
                child: const Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
