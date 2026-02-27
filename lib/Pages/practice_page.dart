import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  Map<String, dynamic>? getData;
  Map<String, dynamic>? doneData;

  Future getapi() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://dummy.restapiexample.com/api/v1/employee/1'),
    );
    if (response.statusCode == 200) {
      getData = jsonDecode(response.body);
      doneData = getData!['data'];
      print(doneData);
    }
  }

  @override
  void initState() {
    super.initState();
    getapi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: doneData == null
            ? CircularProgressIndicator()
            : Text(doneData!['employee_name'].toString()),
        centerTitle: true,
      ),
      body: Column(children: [

        ],
      ),
    );
  }
}
