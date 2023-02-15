import 'package:flutter/material.dart';
import 'dart:io';
// import 'dart:ui';
import 'dart:math';
import 'package:amid/list_details.dart';

// A widget that displays the picture taken by the user.
class InferencePictureScreen extends StatelessWidget {
  final String imagePath;
  final List<dynamic> monuments;
  final double height, width;
  const InferencePictureScreen(
      {super.key,
      required this.imagePath,
      required this.monuments,
      required this.height,
      required this.width});

  // for (var item in rec) {}
  @override
  Widget build(BuildContext context) {
    File imgfile = File(imagePath);
    Image img = Image.file(imgfile);

    return Scaffold(
      appBar: AppBar(title: const Text('Inference Results')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
              image: AssetImage('assets/homepage.jpg'), fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                // Image.file(File(imagePath)),
                img,
                for (var monument in monuments)
                  CustomPaint(
                    painter: RectanglePainter(
                      // x: 0,
                      // y: 0,
                      // w: 392,
                      // h: 524,

                      x: monument['rect']['x'] * width,
                      y: monument['rect']['y'] * height,
                      w: (monument['rect']['x'] + monument['rect']['w']) *
                          width,
                      h: (monument['rect']['y'] + monument['rect']['h']) *
                          height,
                      image: imgfile,
                    ),
                    child: Container(),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                color: const Color.fromARGB(0, 0, 0, 0),
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

//paints rectangle over image
class RectanglePainter extends CustomPainter {
  double x, y, w, h;
  File image;
  RectanglePainter(
      {required this.x,
      required this.y,
      required this.w,
      required this.h,
      required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 1;

    debugPrint("x: $x\ty: $y\tw: $w\th: $h");
    // canvas.drawLine(Offset(a, c), Offset(b, c), paint);
    // canvas.drawLine(Offset(a, c), Offset(a, d), paint);
    // canvas.drawLine(Offset(b, c), Offset(b, d), paint);
    // canvas.drawLine(Offset(b, d), Offset(a, d), paint);
    // canvas.drawLine(Offset(0, 0), Offset(0, 10), paint);
    canvas.drawLine(Offset(x, y), Offset(w, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, h), paint);
    canvas.drawLine(Offset(w, y), Offset(w, h), paint);
    canvas.drawLine(Offset(x, h), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
