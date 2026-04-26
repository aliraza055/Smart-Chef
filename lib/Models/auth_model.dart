import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_chef/Models/app_user.dart';
import 'package:smart_chef/Models/toast_error.dart';
import 'package:smart_chef/Pages/bottom_navigation.dart';
import 'package:smart_chef/Routers/page_router.dart';

class AuthModel {
  Future<void> signup(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, PageRouter.bottomNav);

      User user = credential.user!;

      user.updateDisplayName(name);
      await user.reload();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .set(
            AppUser(
              uid: user.uid,
              name: name,
              gmail: email,
              imageUrl: 'imageUrl',
              totalFavorites: 0,
              totalRecipes: 0,
              createdAt: DateTime.now(),
            ).toMap(),
          );
      ToastError().showToast(
        message: 'Create user successful!',
        bgColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastError().showToast(
          message: "Your password is weak!",
          bgColor: Colors.red,
        );
      } else if (e.code == 'email-already-in-use') {
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
            Navigator.pushReplacementNamed(context, PageRouter.bottomNav);
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
