import 'package:flutter/material.dart';

class DeitalPage extends StatefulWidget {
  const DeitalPage({super.key});

  @override
  State<DeitalPage> createState() => _DeitalPageState();
}

class _DeitalPageState extends State<DeitalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ClipRRect(
            child: Image.asset(
              'images/receipe1.jpg',
              width: double.infinity,
              // height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
