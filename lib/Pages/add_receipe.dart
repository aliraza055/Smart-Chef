import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Models/toast_error.dart';
import 'package:smart_chef/Models/upload_recepies.dart';
import 'package:smart_chef/Services/image_picker.dart';
import 'package:smart_chef/Services/image_upload.dart';
import 'package:smart_chef/Widgets/customDropdown.dart';
import 'package:smart_chef/Widgets/textfield_widget.dart';

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
  final imagePicker = ImagePickerService();
  final imageUpload = ImageUploadService();

  List<String> receipes = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Biryani',
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
                    final pickedImage = await imagePicker.pickFromGallery();
                    if (pickedImage != null) {
                      setState(() {
                        image = pickedImage;
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
                  child: CustomTextField(
                    controller: titleController,
                    hintText: 'Enter title',
                    errorText: 'Enter the title',
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomTextField(
                    controller: descritionController,
                    hintText: 'Enter description',
                    errorText: 'Enter your Description',
                  ),
                ),
                SizedBox(height: 20),
                CustomDropdown(
                  items: receipes,
                  hintText: 'Select Cateogry',
                  onChanged: (value) {
                    setState(() {
                      selecItem = value;
                    });
                  },
                  errorText: 'please select a category',
                ),

                SizedBox(height: 20),
                CustomDropdown<String>(
                  items: const ['easy', 'medium', 'hard'],
                  hintText: 'Select difficulty',
                  value: difficulty,
                  errorText: 'Please select difficulty',
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
                  child: CustomTextField(
                    controller: ingridentsController,
                    hintText: 'Enter ingridents',
                    errorText: 'Enter the ingridents',
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    if (!_formkey.currentState!.validate()) return;
                    if (!validateImage()) return;
                    await UploadRecepie().uploadReceipes(
                      name: titleController.text.trim(),
                      des: descritionController.text.trim(),
                      category: selecItem!,
                      user: user!,
                      difficulity: difficulty!,
                      ingridents: ingridentsController.text.trim(),
                      image: image!,
                    );
                    ToastError().showToast(
                      message: 'Recipe Added Successfully!',
                      bgColor: Colors.green,
                    );
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
