import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastError {
  void showToast({required String message, required Color bgColor}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: bgColor,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      fontSize: 16.0,
    );
  }
}
