import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Widgets/upper_contanier.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UpperContanier(),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(children: [Text('Categories'), CategoryTile()]),
          ),
        ],
      ),
    );
  }
}
