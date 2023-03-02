import 'dart:async';
import 'package:amid/pages/inferenced_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amid/pages/login.dart';
import 'package:amid/utility/process_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late ImagePicker _picker;
  bool _imgLoading = false;
  bool _yolo = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
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
    _picker = ImagePicker();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    _closetfModel();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;
  dynamic rec;
  @override
  Widget build(BuildContext context) {
    if (_imgLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text('Home')),
        body: Column(
          children: [
            FutureBuilder<void>(
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
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          user == null ? '' : user?.photoURL ?? ''),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user == null ? '' : user!.displayName ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user == null ? '' : user!.email!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(title: 'Login'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //to show loading screen while inference is ran
            setState(() {
              _imgLoading = true;
            });
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;
              // Attempt to take a picture and get the file `image`
              // where it was saved.
              XFile image = await _controller.takePicture();
              image = await rotateImg(image.path);

              final resizedImage = await resizeImage(image);
              if (_yolo) {
                final stopwatch = Stopwatch();
                stopwatch.start();
                var yoloResponse = await _yoloModel(image.path);
                stopwatch.stop();
                debugPrint(
                    "response time: ${stopwatch.elapsedMilliseconds.toString()}");
                debugPrint(yoloResponse.toString());
                rec = yoloResponse?.data['predictions'];
              } else {
                rec = await _detectMonument(image.path);
              }
              // run model on taken picture and send result on debug print
              _debugPrint(rec);

              //to show inference results
              setState(() {
                _imgLoading = false;
              });
              if (!mounted) return;
              // If the picture was taken, display it on a new screen.
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InferencePictureScreen(
                    imagePath: resizedImage.path,
                    monuments: rec,
                    height: 514,
                    width: 392,
                  ),
                ),
              );
            } catch (e) {
              debugPrint(e.toString());
            }
          },

          child: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: const Color.fromARGB(255, 13, 174, 174),
              border: Border.all(
                width: 4,
                color: const Color.fromARGB(255, 50, 196, 210),
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 30,
            ),
          ),
          // child: const Icon(Icons.camera_alt),
        ),
        bottomNavigationBar: BottomAppBar(
          // color: const Color.fromARGB(0, 255, 255, 255),
          child: SizedBox(
            height: 90.0,
            // width: MediaQuery.of(context).size.width - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
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
                    tooltip: 'YoLo',
                    iconSize: 30,
                    color: Colors.white,
                    // icon: const Icon(Icons.upload),
                    icon: Icon(
                      _yolo ? Icons.toggle_on : Icons.toggle_off,
                      size: 33,
                    ),
                    onPressed: () async {
                      if (_yolo) {
                        setState(() {
                          _yolo = false;
                        });
                      } else {
                        setState(() {
                          _yolo = true;
                        });
                        if (!mounted) return;
                      }
                    },
                  ),
                ),
                //yolo text
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    _yolo ? 'Online' : 'On Device',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 13, 174, 174),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // createIcon(Icons.flash_on),
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
                      setState(() {
                        _imgLoading = true;
                      });
                      XFile? galaryImage =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (!mounted) return;
                      if (galaryImage == null) {
                        setState(() {
                          _imgLoading = false;
                        });

                        return;
                      }
                      galaryImage = await rotateImg(galaryImage.path);
                      final galResized = await resizeImage(galaryImage);
                      if (_yolo) {
                        var yoloResponse = await _yoloModel(galaryImage.path);
                        debugPrint(yoloResponse.toString());
                        rec = yoloResponse?.data['predictions'];
                        debugPrint(rec.runtimeType.toString());
                        debugPrint(yoloResponse!.headers.toString());
                      } else {
                        rec = await _detectMonument(galaryImage.path);
                      }
                      _debugPrint(rec);
                      setState(() {
                        _imgLoading = false;
                      });
                      if (!mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InferencePictureScreen(
                            imagePath: galResized.path,
                            monuments: rec,
                            height: 524,
                            width: 392,
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
}

//run inference on ssd model and return results
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

// get inferencee result from online yolo model
Future<Response<dynamic>?> _yoloModel(String imagePath) async {
  final formData = FormData.fromMap({
    'img': MultipartFile.fromFileSync(
      imagePath,
      filename: imagePath.split('/').last,
    ),
  });
  final response = Dio().post(
    'https://detectmonuments.azurewebsites.net/api/',
    data: formData,
    onSendProgress: (count, total) =>
        debugPrint('\nsent: $count\ttotal: $total\n'),
  );
  return response;
}

//function to laod tflite model
Future<void> _inittfModel() async {
  String? res = await Tflite.loadModel(
      model: "assets/models/monument512.tflite",
      labels: "assets/labels/test_label.txt",
      numThreads: 1, // defaults to 1
      // defaults to true, set to false to load resources outside assets
      isAsset: true,
      // defaults to false, set to true to use GPU delegate
      useGpuDelegate: false);
  debugPrint(res);
}

// closes tflite model
Future<void> _closetfModel() async {
  await Tflite.close();
}

// print inference results
void _debugPrint(var rec) {
  if (!kDebugMode) {
    return;
  }
  String output = "";
  for (var item in rec) {
    output +=
        "${item['detectedClass'] ?? item['DetectedClass'] ?? 'null'}: ${item['confidenceInClass']} '\n"
        "x: '${item['rect']['x']} '\t"
        "y: '${item['rect']['y']} '\t"
        "w: '${item['rect']['w']} '\t"
        "h: '${item['rect']['h']}\n";
  }
  debugPrint(output);
}

class SnackbarGlobal {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
