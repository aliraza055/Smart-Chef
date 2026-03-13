import 'package:flutter/material.dart';

class FavoriteItem extends StatefulWidget {
  const FavoriteItem({super.key});

  @override
  State<FavoriteItem> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('favorite item'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 10),
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.white10,
          border: Border.all(color: Colors.greenAccent, width: 1.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                'images/receipe1.jpg',
                height: 180,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lo Seintso',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Pasta Bonlaize with Italian style',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Center(child: Text('time')),
                  ),
                ),
                Container(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Time')),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('likes'),
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
