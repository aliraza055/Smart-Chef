import 'package:flutter/material.dart';

class UpperContanier extends StatelessWidget {
  const UpperContanier({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height / 3.8,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      //margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("hi Mr. Ali Raza"),
                  Text('Checking the amazing receipes...'),
                ],
              ),
              ClipOval(
                child: Image.asset('images/boy.jpg', height: 60, width: 60),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(right: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hint: Text('Search.....'),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
