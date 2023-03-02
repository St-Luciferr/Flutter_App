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
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
                image: AssetImage('assets/images/homepage.jpg'),
                fit: BoxFit.fill),
          ),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              for (var monument in widget.monuments)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 196, 232, 228),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        offset: Offset(0, 0),
                        blurRadius: 4.0,
                      ),
                    ],
                    // border: Border.all(
                    //   width: 2,
                    //   color: const Color.fromARGB(255, 50, 196, 210),
                    // ),
                  ),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //displays monument image
                      Align(
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: getImage('test_monument'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(28),
                                  color:
                                      const Color.fromARGB(255, 212, 219, 219),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromARGB(255, 50, 196, 210),
                                  ),
                                ),
                                child: Image(
                                    image: NetworkImage(snapshot.data ?? ''),
                                    height: 300,
                                    width: 300),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(28),
                                  color:
                                      const Color.fromARGB(255, 212, 219, 219),
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromARGB(255, 50, 196, 210),
                                  ),
                                ),
                                height: 120,
                                width: 120,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                          },
                        ),
                      ),
                      // FutureBuilder(
                      //     future: getData("Dattatreya Temple"),
                      //     builder: (context, snapshot) {}),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: getData('Dattatreya Temple'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            debugPrint(snapshot.data.toString());
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    snapshot.data?['Monument_Name'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 80, 80, 80)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 2, 71, 88),
                                      foregroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fixedSize: const Size(150, 35),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Text('View More >'),
                                    onPressed: () async {
                                      // Validate the form
                                    },
                                  ),
                                ),
                                // Center(
                                //   child: formattedDetails(
                                //     "Confidence Score: ",
                                //     monument['confidenceInClass'].toString(),
                                //   ),
                                // ),

                                // formattedDetails(
                                //   "Construction Date: ",
                                //   snapshot.data?["Construction_Date"],
                                // ),
                                // formattedDetails(
                                //   "Constructed By: ",
                                //   snapshot.data?["Constructed_by"],
                                // ),
                                // formattedDetails(
                                //   "Detailed Description: ",
                                //   "${snapshot.data?["Detailed_description"].substring(0, 210)}...",
                                // ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ));
  }
}
