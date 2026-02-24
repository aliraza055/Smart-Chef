import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Models/toast_error.dart';
import 'package:smart_chef/Pages/home_page.dart';

class AuthModel {
  Future<void> signup(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
            User? user = FirebaseAuth.instance.currentUser!;
            user.updateDisplayName(name);
            await user.reload();
            Map<String, dynamic> userinfo = {
              'name': name,
              'gmail': email,
              'image': '',
            };
            await userData(user.uid, userinfo);
            ToastError().showToast(
              message: 'Create user successful!',
              bgColor: Colors.green,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Homepage()),
              (route) => false,
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastError().showToast(
          message: "Your password is weak!",
          bgColor: Colors.red,
        );
      } else if (e.code == 'email-already-use-in') {
        ToastError().showToast(
          message: "This email is already used!",
          bgColor: Colors.red,
        );
      } else {
        ToastError().showToast(
          message: 'Error:${e.message}',
          bgColor: Colors.red,
        );
      }
    } catch (e) {
      ToastError().showToast(
        message: 'An unexpected error',
        bgColor: Colors.red,
      );
    }
  }

  Future<void> signIn(
    BuildContext context,
    String gmail,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: gmail, password: password)
          .then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => Homepage()),
              (route) => false,
            );
            ToastError().showToast(
              message: 'login Sucessful!',
              bgColor: Colors.green,
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ToastError().showToast(message: 'User not found!', bgColor: Colors.red);
      } else if (e.code == 'wrong-password') {
        ToastError().showToast(
          message: 'incorrect password',
          bgColor: Colors.red,
        );
      } else {
        ToastError().showToast(
          message: 'Error:${e.message}',
          bgColor: Colors.red,
        );
      }
    } catch (e) {
      ToastError().showToast(message: 'Unexpected error', bgColor: Colors.red);
    }
  }
}

Future userData(String id, Map<String, dynamic> userinfo) async {
  await FirebaseFirestore.instance.collection('Users').doc(id).set(userinfo);
}
