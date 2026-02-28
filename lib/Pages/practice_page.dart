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
  List? doneData;

  Future getapi() async {
    http.Response response;
    response = await http.get(
      Uri.parse('https://dummy.restapiexample.com/api/v1/employees'),
    );
    if (response.statusCode == 200) {
      getData = jsonDecode(response.body);
      doneData = getData!['data'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          doneData == null
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: doneData!.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                          ),
                          child: Column(
                            children: [Text(doneData![index]['employee_name'])],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
