import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddReceipe extends StatefulWidget {
  const AddReceipe({super.key});

  @override
  State<AddReceipe> createState() => _AddReceipeState();
}

class _AddReceipeState extends State<AddReceipe> {
  String? selecItem;
  List<String> receipes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Desserts',
    'Beverages',
    'Fast Food',
  ];
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
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: DottedBorder(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(),
                    child: Column(
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

              // DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     labelText: "Select Country",
              //     border: OutlineInputBorder(),
              //   ),
              //   items: ["Pakistan", "India", "USA", "UK"].map((value) {
              //     return DropdownMenuItem<String>(value: value, child: Text(value));
              //   }).toList(),
              //   onChanged: (value) {
              //     print("Selected: $value");
              //   },
              // ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Enter tile'),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Enter description '),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              DropdownButtonFormField<String>(
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
              // Container(
              //   height: 50,
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              //   decoration: BoxDecoration(
              //     color: Colors.blueGrey.shade100,
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text('Enter category'),
              //       Icon(Icons.keyboard_arrow_down),
              //     ],
              //   ),
              // ),
              SizedBox(height: 20),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Enter Ingreditions'),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hint: Center(child: Text('Done')),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
