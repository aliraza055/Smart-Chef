import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:smart_chef/Models/receipe_model.dart';

class ReceipeServices {
  Future<void> addReceipe(ReceipeModel receipes) async {
    final id = randomAlphaNumeric(10);
    await FirebaseFirestore.instance
        .collection('Receipes')
        .doc(id)
        .set(receipes.toMap());
  }
}
