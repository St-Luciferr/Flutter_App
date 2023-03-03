import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<Map<String, dynamic>>? getData(String name) async {
  dynamic monument;
  await FirebaseFirestore.instance
      .collection("monuments")
      .doc(name)
      .get()
      .then((value) {
    monument = value.data();
  });
  return monument;
}

Future<String> getImage(String name) async {
  final imagesRef = FirebaseStorage.instance.ref().child("images/$name.jpg");
  return imagesRef.getDownloadURL();
}
