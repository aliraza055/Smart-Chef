import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_chef/Models/receipe_model.dart';
import 'package:smart_chef/Models/toast_error.dart';
import 'package:http/http.dart' as http;

class AddReceipe extends StatefulWidget {
  const AddReceipe({super.key});

  @override
  State<AddReceipe> createState() => _AddReceipeState();
}

class _AddReceipeState extends State<AddReceipe> {
  String? selecItem;
  String? difficulty;
  File? image;
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descritionController = TextEditingController();
  final ingridentsController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  List<String> receipes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Desserts',
    'Beverages',
    'Fast Food',
  ];
  bool validateImage() {
    if (image == null) {
      ToastError().showToast(
        message: 'Please select an image',
        bgColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  Future<String?> SendImage() async {
    if (image != null) {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/dhob4di7g/image/upload',
      );
      final request = http.MultipartRequest('post', uri);
      request.fields['upload_preset'] = 'upload_preset_file';
      request.files.add(await http.MultipartFile.fromPath('file', image!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final resbody = await response.stream.bytesToString();
        final decode = jsonDecode(resbody);
        final imageUrl = decode['secure_url'];
        return imageUrl;
      } else {
        ToastError().showToast(
          message: 'Upload fails${response.statusCode}',
          bgColor: Colors.red,
        );
      }
    } else {
      ToastError().showToast(message: 'Select image', bgColor: Colors.red);
    }
  }

  Future sendData() async {
    final image = await SendImage();
    final receipe = ReceipeModel(
      name: titleController.text,
      description: descritionController.text,
      category: selecItem!,
      image: image!,
      userName: user!.displayName!,
      ingridents: ingridentsController.text,
      difficulity: difficulty!,
      userphoto: user!.photoURL!,
      likes: 0,
      rated: 0,
      time: 20,
    );
    await FirebaseFirestore.instance
        .collection('Receipes')
        .doc('1')
        .set(receipe.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Add New Receipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    final imageSource = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (imageSource == null) {
                      return;
                    } else {
                      setState(() {
                        image = File(imageSource.path);
                      });
                    }
                  },
                  child: Center(
                    child: DottedBorder(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(),
                        child: image != null
                            ? Image.file(image!, fit: BoxFit.cover)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt),
                                  SizedBox(height: 20),
                                  Text("Add Images"),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: descritionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the title';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hint: Text('Enter Description'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the title';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hint: Text('Enter tile'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  hint: const Text('Enter category'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: receipes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selecItem = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  hint: Text('Select difficulty level'),
                  icon: Icon(Icons.keyboard_arrow_down),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['easy', 'medium', 'hard'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      difficulty = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: ingridentsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the Ingridents';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hint: Text('Enter ingridents'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (!_formkey.currentState!.validate()) return;
                    if (!validateImage()) return;
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 40),
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text('Done')),
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
