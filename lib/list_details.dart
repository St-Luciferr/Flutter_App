import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_core/firebase_core.dart';

class ListViews extends StatefulWidget {
  const ListViews({super.key, required this.monuments});
  final List<dynamic> monuments;
  @override
  State<ListViews> createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  final storageRef = FirebaseStorage.instance.ref();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? url;

  Future<String> getImage(String name) {
    final imagesRef = storageRef.child("images/$name.JPG");
    return imagesRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detected Monuments'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          for (var monument in widget.monuments)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //displays monument image
                Align(
                  alignment: Alignment.topLeft,
                  child: FutureBuilder(
                    future: getImage('test_monument'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(28),
                            color: const Color.fromARGB(255, 212, 219, 219),
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 50, 196, 210),
                            ),
                          ),
                          child: Image(
                              image: NetworkImage(snapshot.data ?? ''),
                              height: 120,
                              width: 120),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(28),
                            color: const Color.fromARGB(255, 212, 219, 219),
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 50, 196, 210),
                            ),
                          ),
                          height: 120,
                          width: 120,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
                Text(
                    "Detected Monument: ${monument['detectedClass'] ?? monument['DetectedClass'] ?? 'null'} \nConfidence Score: ${monument['confidenceInClass']}",
                    textAlign: TextAlign.left),
                const Text('Date of Construction: 2056/01/24',
                    textAlign: TextAlign.left),
                const Text('Constructed By: Santosh Pandey',
                    textAlign: TextAlign.left),
                const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                    'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                    'Cursus vitae congue mauris rhoncus. Lectus proin nibh nisl condimentum',
                    textAlign: TextAlign.justify),
              ],
            ),
        ],
      ),
    );
  }
}
