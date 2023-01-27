import 'dart:io';
import 'package:flutter/material.dart';

class ListViews extends StatefulWidget {
  const ListViews({super.key, required this.monuments});
  final List<String> monuments;
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
      body: ListView(padding: EdgeInsets.all(10), children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image(
                    image: AssetImage('img/img.jpg'), height: 150, width: 150)),
            Text('name: Khatra Monument', textAlign: TextAlign.left),
            Text('Date of Construction: 2056/01/24', textAlign: TextAlign.left),
            Text('Constructed By: Santosh Pandey', textAlign: TextAlign.left),
            Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                'Cursus vitae congue mauris rhoncus. Lectus proin nibh nisl condimentum',
                textAlign: TextAlign.justify),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image(
                    image: AssetImage('img/img.jpg'), height: 150, width: 150)),
            Text('name: Khatra Monument', textAlign: TextAlign.left),
            Text('Date of Construction: 2056/01/24', textAlign: TextAlign.left),
            Text('Constructed By: Santosh Pandey', textAlign: TextAlign.left),
            Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                'Cursus vitae congue mauris rhoncus. Lectus proin nibh nisl condimentum',
                textAlign: TextAlign.justify),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image(
                    image: AssetImage('img/img.jpg'), height: 150, width: 150)),
            Text('name: Khatra Monument', textAlign: TextAlign.left),
            Text('Date of Construction: 2056/01/24', textAlign: TextAlign.left),
            Text('Constructed By: Santosh Pandey', textAlign: TextAlign.left),
            Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                'Cursus vitae congue mauris rhoncus. Lectus proin nibh nisl condimentum',
                textAlign: TextAlign.justify),
          ],
        ),
      ]),
    );
  }
}
