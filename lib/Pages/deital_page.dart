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
      body: Stack(
        children: [
          ClipRRect(
            child: Image.asset(
              'images/receipe1.jpg',
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.width / 1),
            padding: EdgeInsets.only(top: 15, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              color: Colors.blueGrey.shade100,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lime Ulto Gmam',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('⭐'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
