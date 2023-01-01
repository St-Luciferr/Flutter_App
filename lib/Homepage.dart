import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:js';

// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  late File cameraFile;
  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to Flutter'),
            backgroundColor: Color.fromARGB(255, 97, 153, 199),
          ),
          body: Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 50,
                    // ),
                    CustomButton(
                      title: 'Option 1',
                      icon: Icons.camera_alt,
                      onClick: () => {},
                    ),
                    // SizedBox(
                    //   height: 40,
                    // ),
                    CustomButton(
                      title: 'Option 2',
                      icon: Icons.image_outlined,
                      onClick: () => {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      title: 'Open Camera',
                      icon: Icons.camera_alt,
                      onClick: getImage,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      title: 'Upload Image',
                      icon: Icons.image_outlined,
                      onClick: () => {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      title: 'Option 1',
                      icon: Icons.camera_alt,
                      onClick: () => {},
                    ),
                    CustomButton(
                      title: 'Option 2',
                      icon: Icons.image_outlined,
                      onClick: () => {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            
            elevation: 10.0,
            child: const Icon(Icons.keyboard_arrow_right),
            onPressed: () {},
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    '''Profile\nemail address\nname''',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text('Item 1'),
                ),
                ListTile(
                  title: Text('Item 2'),
                ),
              ],
            ),
          ),
        ));
  }
}

// class Page2 extends StatelessWidget {
//   const Page2({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//           appBar: AppBar(
//             title: const Text('Second Page'),
//             backgroundColor: const Color.fromARGB(255, 97, 153, 199),
//             leading: BackButton(
//               onPressed: () {},
//             ),
//           ),
//           body: const Center(
//             child: Text('PAGE 2'),
//           ),
//         );
//   }
// }

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    height: 150,
    width: 150,
    decoration: 
    
    BoxDecoration(
      color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 185, 184, 184),
            blurRadius: 2,
            spreadRadius: 1,
          )
        ]),
    child: ElevatedButton(
      onPressed: onClick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon), SizedBox(height: 10), Text(title)],
      ),
    ),
  );
}
