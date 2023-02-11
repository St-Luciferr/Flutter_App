import 'package:flutter/material.dart';
import 'dart:io';
// import 'dart:ui';
import 'dart:math';
import 'package:amid/list_details.dart';

// A widget that displays the picture taken by the user.
class InferencePictureScreen extends StatelessWidget {
  final String imagePath;
  final List<dynamic> monuments;
  const InferencePictureScreen(
      {super.key, required this.imagePath, required this.monuments});

  // for (var item in rec) {}
  @override
  Widget build(BuildContext context) {
    File imgfile = File(imagePath);
    Image img = Image.file(imgfile);

    double height = MediaQuery.of(context).size.height - 300;
    double width = MediaQuery.of(context).size.width;
    debugPrint("height: $height\twidth: $width");

    return Scaffold(
      appBar: AppBar(title: const Text('Inference Results')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Container(
        padding: const EdgeInsets.all(0),
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
                      w: monument['rect']['w'] * width,
                      h: monument['rect']['h'] * height,
                    ),
                    child: Container(),
                  ),
              ],
            ),
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

//paints rectangle over image
class RectanglePainter extends CustomPainter {
  double x, y, w, h;
  RectanglePainter(
      {required this.x, required this.y, required this.w, required this.h});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 1;
    double a, b, c, d;
    a = x - w / 2 + 50;
    b = x + w / 2 + 50;
    c = y - h / 2 + 90;
    d = y + h / 2 + 90;

    canvas.drawLine(Offset(a, c), Offset(b, c), paint);
    canvas.drawLine(Offset(a, c), Offset(a, d), paint);
    canvas.drawLine(Offset(b, c), Offset(b, d), paint);
    canvas.drawLine(Offset(b, d), Offset(a, d), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
