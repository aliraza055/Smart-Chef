import 'package:flutter/material.dart';
import 'package:smart_chef/Pages/add_receipe.dart';
import 'package:smart_chef/Widgets/category_tile.dart';
import 'package:smart_chef/Widgets/receipe_container.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            UpperContanier(),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CategoryTile(),
                  SizedBox(height: 10),
                  ReceipeContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddReceipe()),
          );
        },
      ),
    );
  }
}
