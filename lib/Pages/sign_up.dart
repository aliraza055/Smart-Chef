import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smart_chef/Models/auth_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _keyform = GlobalKey<FormState>();
  final _nameCont = TextEditingController();
  final _gmailCont = TextEditingController();
  final _passwordCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,

            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Image.asset(
                'images/chef.jpg',
                height: 130,
                width: 130,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 220, left: 40, right: 40, bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xffffefbf),
            ),
            child: Form(
              key: _keyform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Singup page',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black12,
                    ),
                    child: TextFormField(
                      controller: _nameCont,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your name';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hint: Text('Enter your name'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Text(
                    'Gmail',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black12,
                    ),
                    child: TextFormField(
                      controller: _gmailCont,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter valid gmail';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hint: Text('Enter your gmail'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black12,
                    ),
                    child: TextFormField(
                      controller: _passwordCont,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Enter strong password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hint: Text('Enter your password'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_keyform.currentState!.validate()) {
                        AuthModel().signup(
                          context,
                          _nameCont.text,
                          _gmailCont.text,
                          _passwordCont.text,
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: Text('Sinup')),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('If you dont have account!'),
                      Text(
                        'Singup',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
