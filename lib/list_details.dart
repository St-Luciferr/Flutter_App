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

  Future<Map<String, dynamic>>? getData(String name) async {
    dynamic monument;
    await firestore.collection("monuments").doc(name).get().then((value) {
      monument = value.data();
    });
    return monument;
  }

  Future<void> getTestData(String name) async {
    final data = await firestore.collection('test').doc(name).get();
    debugPrint(data.data().toString());
  }

  Future<String> getImage(String name) async {
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
                // FutureBuilder(
                //     future: getData("Dattatreya Temple"),
                //     builder: (context, snapshot) {}),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: getData('Dattatreya Temple'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      debugPrint(snapshot.data.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formattedDetails(
                            "Monument Name: ",
                            snapshot.data?['Monument_Name'],
                          ),
                          formattedDetails(
                            "Confidence Score: ",
                            monument['confidenceInClass'].toString(),
                          ),
                          formattedDetails(
                            "Construction Date: ",
                            snapshot.data?["Construction_Date"],
                          ),
                          formattedDetails(
                            "Constructed By: ",
                            snapshot.data?["Constructed_by"],
                          ),
                          formattedDetails(
                            "Detailed Description: ",
                            snapshot.data?["Detailed_description"],
                          ),
                        ],
                      );
                    } else
                      return Container();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

Widget formattedDetails(String label, String text) {
  return RichText(
    textAlign: TextAlign.justify,
    text: TextSpan(
        text: label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ]),
  );
}
