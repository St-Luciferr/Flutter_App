import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'listDetails.dart';
import 'resizeImage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.camera});
  final CameraDescription camera;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _InitializeControllerFuture;
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
    _InitializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder<void>(
        future: _InitializeControllerFuture,
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
            await _InitializeControllerFuture;
            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            final resized_img = await resizeImage(image);
            // run model on taken picture and send result on debug print
            var recognitions = await Tflite.detectObjectOnImage(
                path: image.path, // required
                model: "SSDMobileNet",
                imageMean: 0,
                imageStd: 255,
                threshold: 0.9, // defaults to 0.1
                numResultsPerClass: 1, // defaults to 5
                asynch: true // defaults to true
                );
            _debugPrint(recognitions);
            // await Tflite.close();
            if (!mounted) return;
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  monuments: recognitions!,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
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
  DisplayPictureScreen(
      {super.key, required this.imagePath, required this.monuments});

  // for (var item in rec) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inference Results')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
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
                  child: Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    child: Transform.rotate(
                      angle: pi,
                      child: Icon(Icons.expand_circle_down),
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
