import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeitalPage extends StatefulWidget {
  final dynamic receipe;
  const DeitalPage({super.key, required this.receipe});

  @override
  State<DeitalPage> createState() => _DeitalPageState();
}

class _DeitalPageState extends State<DeitalPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipRRect(
              child: Image.network(
                widget.receipe['image'],
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 1,
              ),
              padding: EdgeInsets.only(top: 15, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.blueGrey.shade200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.receipe['name'],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('⭐'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Receipe by',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'images/boy.jpg',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user!.displayName ?? 'Ali Raza Maqbol',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text('Chef'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent.shade100,
                            ),
                            child: Icon(Icons.call),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent.shade100,
                            ),
                            child: Icon(Icons.message),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(widget.receipe['description']),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 70,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Icon(Icons.notifications)),
                            ),
                            Column(
                              children: [
                                Text('Cusine'),
                                Text(
                                  widget.receipe['category'],
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10),
                        height: 70,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          border: Border.all(width: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Icon(Icons.notifications)),
                            ),
                            Column(
                              children: [
                                Text('time'),
                                // SizedBox(height: 10),
                                Text(
                                  widget.receipe['time'].toString(),
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ingridients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(children: [Text(widget.receipe['ingridents'])]),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 40,
        margin: EdgeInsets.only(left: 100, right: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.orange,
        ),
        child: Center(child: Text('Add to favorite')),
      ),
    );
  }
}
