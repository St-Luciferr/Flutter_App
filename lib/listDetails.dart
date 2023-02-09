import 'dart:io';
import 'package:flutter/material.dart';

class ListViews extends StatefulWidget {
  ListViews({super.key, required this.monuments});
  final List<dynamic> monuments;
  @override
  State<ListViews> createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detected Monuments'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          for (var monument in widget.monuments)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Image(
                      image: AssetImage('assets/img.jpg'),
                      height: 150,
                      width: 150),
                ),
                Text(
                    "Detected Monument: ${monument['detectedClass']} \nConfidence Score: ${monument['confidenceInClass']}",
                    textAlign: TextAlign.left),
                Text('Date of Construction: 2056/01/24',
                    textAlign: TextAlign.left),
                Text('Constructed By: Santosh Pandey',
                    textAlign: TextAlign.left),
                Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                    'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                    'Cursus vitae congue mauris rhoncus. Lectus proin nibh nisl condimentum',
                    textAlign: TextAlign.justify),
              ],
            ),
        ],
      ),
    );
  }
}
