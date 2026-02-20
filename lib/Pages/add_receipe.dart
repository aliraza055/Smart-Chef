import 'package:flutter/material.dart';

class AddReceipe extends StatefulWidget {
  const AddReceipe({super.key});

  @override
  State<AddReceipe> createState() => _AddReceipeState();
}

class _AddReceipeState extends State<AddReceipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Add Receipe'),
      ),
      body: Column(children: [Container()]),
    );
  }
}
