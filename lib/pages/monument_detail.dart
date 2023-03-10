import 'package:flutter/material.dart';
import 'package:amid/utility/firebase_actions.dart';
import 'package:amid/components/formatted_text.dart';

class DetailedView extends StatelessWidget {
  final String monument;
  final String title;
  const DetailedView({super.key, required this.monument, required this.title});

  @override
  Widget build(BuildContext context) {
    double size = 16;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/inner_background.jpg'),
                fit: BoxFit.fill),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(99, 227, 250, 247),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    offset: Offset(0, 0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //displays monument image
                  Align(
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: getImage(monument),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(28),
                              color: const Color.fromARGB(255, 212, 219, 219),
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 50, 196, 210),
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
                                height: 240,
                                width: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 212, 219, 219),
                              border: Border.all(
                                width: 2,
                                color: const Color.fromARGB(255, 50, 196, 210),
                              ),
                            ),
                            height: 240,
                            width: 320,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder(
                    future: getData(monument),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        debugPrint(snapshot.data.toString());
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            formattedDetails(
                              "Construction Date: ",
                              snapshot.data?["Construction_Date"],
                              size,
                            ),
                            const Divider(
                              thickness: 1,
                              height: 5,
                            ),
                            formattedDetails(
                              "Constructed By: ",
                              snapshot.data?["Constructed_by"],
                              size,
                            ),
                            const Divider(
                              thickness: 1,
                              height: 5,
                            ),
                            formattedDetails(
                              "Architecture Style: ",
                              snapshot.data?["Architecture_Style"],
                              size,
                            ),
                            const Divider(
                              thickness: 1,
                              height: 5,
                            ),
                            formattedDetails(
                              "Main Deity: ",
                              snapshot.data?["Main_Deity"],
                              size,
                            ),
                            const Divider(
                              thickness: 1,
                              height: 5,
                            ),
                            formattedDetails(
                              "Number of Storeys: ",
                              snapshot.data?["Storeys"],
                              size,
                            ),
                            const Divider(
                              thickness: 1,
                              height: 5,
                            ),
                            formattedDetails(
                              "Detailed Description: ",
                              "${snapshot.data?["Detailed_Description"]}",
                              size,
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
            ),
          ),
        ));
  }
}
