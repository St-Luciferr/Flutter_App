import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void addData() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final monuments = db.collection("monuments");
    final data1 = <String, dynamic>{
      "Monument_Name": "Dattatreya Temple",
      "Construction_Date": "between 1428-67",
      "Constructed_by": "King Yaksha Malla (r. 1428-82)",
      "Architecture_Style": "Mandala style",
      "Storeys": "3",
      "Main_Deity": "Dattatreya",
      "Detailed_description": "The Dattatreya Temple stands at the east end of the Tachapal Tol,"
          "a small square on the east side of Bhaktapur. It honors the composite deity Dattatreya,"
          " a personification of the Trimurti of Brahma, Vishnu, and Shiva."
          "According to Slusser and Vajrācārya, the temple was originally founded as a sattal, a kind "
          "of dharmasala or public rest house sometime in the 15th century. It was functionally similar to "
          "the KasthaMandap, an older site in Kathmandu that was destroyed in the April 2015 earthquake and has not "
          "yet been rebuilt. Similar legends are told about both buildings: that each was built from the wood of a single "
          "tree, and that each was founded on the site of a former island within a small lake, upon which a famous Indian jogi "
          "had died. These similar foundation narratives might suggest a desire on the part of the Bhaktapur rulers to 'borrow' "
          "the mythology of the KasthaMandap, thereby enhancing the prestige of Bhaktapur and their 'rival' dharmasala."
          "Both temples were designed in a similar manner. They were laid out on a square footprint with an equal number of open "
          "columns on each side. Morphologically, this form is derived from the Mandap—typically, a modest sixteen-pillared, "
          "open-air hall, usually of only one story. At both temples, the Mandap design was employed but was modified and expanded "
          "to cover a much larger footprint, and lofted skyward with two additional floors to accommodate greater numbers of itinerant"
          " holy men, who might stay at each site for months or even years."
          "The distinction between a Mandap and a sattal is subtle, with the sattal usually designed for more permanent occupation "
          "and with better protection from the elements. But in size and scope, both the Dattatreya and KasthaMandap are more closely "
          "aligned with the sattal form than the usually far humbler (and often one-story) Mandap."
          "The Dattatreya was probably erected between 1428-67, either by King Yaksha Malla (r. 1428-82) or possibly by his son "
          "Raya Malla (r. 1482-1519). It was originally intended as a rest house for Shiva ascetics. At some later date, probably during the "
          "reign of Vishva Malla (r. 1547-60) or Jitamitra Malla (r. 1663-96), the design was altered to change the sattal into that"
          " of a temple for worshipping Dattatreya. This required several architectural changes which fully manifested themselves "
          "over the course of four centuries.First, and most importantly, the open-air layout of the sattal, derived from the Mandap, "
          "was bricked in and enclosed to form a distinct inner sanctum that was visually cut off from the outside world, corresponding to"
          " the central enclosed chamber common to Newari temples (i.e., the garbha-griha, or 'womb room'). Furthermore, the breezy porch "
          "wrapping around the building was infilled with wooden screens, creating a closed, covered ambulatory wrapping around the inner "
          "sanctum; again, mimicking the standard temple form. Thus, the building was converted into a more private, walled-off sanctuary "
          "befitting the deity housed within. The itinerant residents may have been offered alternate accommodations at the nearby "
          "Pujari Math compound, as suggested by a contemporary chronicle.Secondly—and much later, in 1849—a two-story porch and cupola"
          " were added to the west side of the building over the front entrance, breaking the symmetry of the sattal form, which sTill "
          "manifested itself from the exterior. The addition of this porch was clearly not foreseen in the original design of the building. For instance, Slusser notes that the porch railings "
          "which run around the middle level of the building continue uninterrupted behind the rear of the cupola; the floors of the cupola "
          "and the room behind it are not even joined, although they appear so when viewed from the exterior. The ground floor, too, is "
          "architecturally distinct, as the bays of the porch are in the form of an open arcade, while the corresponding spaces behind it "
          "are wooden screens. Slusser suggests this may have been a clumsy attempt to recreate the mukhaMandap entry halls often found in "
          "Indian temple architecture; in Nepal, this form is largely unknown.:"
          "Nonetheless, Slusser notes that at the time of her writing in 1974 that a single yogi remained in residence at the temple, "
          "continuing its original function as a sattal in a most limited way."
          "Hutt notes that in the current era, although the temple is formally dedicated to Dattatreya, the Vishnu aspect of Dattatreya's"
          " divinity is dominant. For instance, Vishnu's conch and discus are mounted on pillars outside the entrance, and a gilded Garuda "
          "(Vishnu's vehicle) is mounted on a tall pole in front of the temple. A wooden figure of the \"Vishnu like\" Dattatreya peers"
          " down at the square from the cupola window over the porch, echoing a similar \"peering down\" motif found at the Shiva-Parvati "
          "temple in Kathmandu."
    };
    monuments.doc("Dattatreya Temple").set(data1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //creates button with gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 13, 174, 174),
                            Color.fromARGB(255, 55, 213, 213),
                            Color.fromARGB(255, 76, 224, 224),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      addData();
                    },
                    child: const Text('Add Data'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

//creates a matrerial color from color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
