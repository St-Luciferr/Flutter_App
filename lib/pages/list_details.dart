import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amid/utility/firebase_actions.dart';
import 'package:amid/pages/monument_detail.dart';
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
                      //displays monument image at center
                      Align(
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: getImage('test_monument'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 212, 219, 219),
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 50, 196, 210),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                      offset: Offset(0, 0),
                                      blurRadius: 4.0,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(snapshot.data ?? ''),
                                    height: 300,
                                    width: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromARGB(255, 212, 219, 219),
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromARGB(255, 50, 196, 210),
                                  ),
                                ),
                                height: 300,
                                width: 300,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                          },
                        ),
                      ),
                      //put gap between image and content
                      const SizedBox(
                        height: 5,
                      ),
                      //show details about the monument
                      FutureBuilder(
                        future: getData(
                          monument['detectedClass'] ??
                              monument['DetectedClass'] ??
                              'null',
                        ),
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
                                      fixedSize: const Size(145, 35),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Text(
                                      'View More >>',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      debugPrint(
                                          "monument: ${monument['detectedClass'] ?? monument['DetectedClass'] ?? ''}");
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DetailedView(
                                            title:
                                                snapshot.data?['Monument_Name'],
                                            monument:
                                                monument['detectedClass'] ??
                                                    monument['DetectedClass'] ??
                                                    '',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
