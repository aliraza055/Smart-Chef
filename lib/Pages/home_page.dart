import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Smart Chef",
            //       style: TextStyle(
            //         color: Colors.amber,
            //         fontSize: 30,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     SizedBox(width: 20),
            //     Image.asset(
            //       height: 50,
            //       width: 50,
            //       fit: BoxFit.cover,
            //       "images/boy.jpg",
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(right: 10),
            //       child: ClipOval(
            //         child: Image.asset('images/boy.jpg', height: 10, width: 10),
            //       ),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Center horizontally
                  children: [
                    SizedBox(
                      width: 110,
                      height: 48,
                      child: Image.asset('images/boy.jpg', fit: BoxFit.cover),
                    ),
                    Text('Order your favorite food!'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipOval(
                    child: Image.asset(
                      'images/boy.jpg',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
