import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:amid/components/app_bar_icons.dart';
import 'package:amid/resize_image.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'list_details.dart';
import 'package:amid/components/inferenced_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.camera});
  final CameraDescription camera;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _inittfModel();
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _closetfModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            final resizedImage = await resizeImage(image);
            File img = File(resizedImage.path);
            var recognitions = await _detectMonument(resizedImage.path);
            var decodedImage = await decodeImageFromList(img.readAsBytesSync());
            double height = decodedImage.height.toDouble();
            double width = decodedImage.width.toDouble();
            debugPrint("height: $height\twidth: $width");
            // run model on taken picture and send result on debug print
            _debugPrint(recognitions);
            if (!mounted) return;
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InferencePictureScreen(
                  imagePath: resizedImage.path,
                  monuments: recognitions!,
                  height: height,
                  width: width,
                ),
              ),
            );
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      bottomNavigationBar: BottomAppBar(
        // color: const Color.fromARGB(0, 255, 255, 255),
        child: SizedBox(
          height: 60.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              createIcon(Icons.flash_on),
              const Spacer(),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                // padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: const Color.fromARGB(255, 13, 174, 174),
                  border: Border.all(
                    width: 4,
                    color: const Color.fromARGB(255, 50, 196, 210),
                  ),
                ),
                child: IconButton(
                  alignment: Alignment.center,
                  tooltip: 'Upload',
                  iconSize: 30,
                  color: Colors.white,
                  // icon: const Icon(Icons.upload),
                  icon: const Icon(Icons.cloud_upload_rounded),
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? galaryImage =
                        await _picker.pickImage(source: ImageSource.gallery);
                    final galResized = await resizeImage(galaryImage);
                    var rec = await _detectMonument(galResized.path);
                    File _img = File(galResized.path);
                    var decodedImage =
                        await decodeImageFromList(_img.readAsBytesSync());
                    double height = decodedImage.height.toDouble();
                    double width = decodedImage.width.toDouble();
                    debugPrint("height: $height\twidth: $width");
                    _debugPrint(rec);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InferencePictureScreen(
                          imagePath: galResized.path,
                          monuments: rec!,
                          height: height,
                          width: width,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Future<List<dynamic>?> _detectMonument(String imgPath) async {
  var recognitions = await Tflite.detectObjectOnImage(
      path: imgPath,
      model: "SSDMobileNet",
      imageMean: 0,
      imageStd: 255,
      threshold: 0.7,
      numResultsPerClass: 1,
      asynch: true);
  return recognitions;
}

//function to laod tflite model
Future<void> _inittfModel() async {
  String? res = await Tflite.loadModel(
      model: "assets/monumentModel.tflite",
      labels: "assets/labels.txt",
      numThreads: 1, // defaults to 1
      // defaults to true, set to false to load resources outside assets
      isAsset: true,
      // defaults to false, set to true to use GPU delegate
      useGpuDelegate: false);
  debugPrint(res);
}

Future<void> _closetfModel() async {
  await Tflite.close();
}

void _debugPrint(var rec) {
  String output = "";
  for (var item in rec) {
    output +=
        "${item['detectedClass']}: ${item['confidenceInClass']} '\nx: '${item['rect']['x']} '\ty: '${item['rect']['y']} '\tw: '${item['rect']['w']} '\th: '${item['rect']['h']}\n";
  }
  debugPrint(output);
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final List<dynamic> monuments;
  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.monuments});

  // for (var item in rec) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inference Results')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/homepage.jpg'), fit: BoxFit.fill),
        ),
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.file(File(imagePath)),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                child: OutlinedButton(
                  onPressed: () =>
                      {Navigator.of(context).push(_createRoute(monuments))},
                  child: SizedBox(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    child: Transform.rotate(
                      angle: pi,
                      child: const Icon(Icons.expand_circle_down),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute(monuments) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ListViews(monuments: monuments),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
