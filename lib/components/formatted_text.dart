import 'package:flutter/material.dart';

Widget formattedDetails(String label, String text, double size) {
  return RichText(
    textAlign: TextAlign.justify,
    text: TextSpan(
        text: label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size,
          color: const Color.fromARGB(255, 80, 80, 80),
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: size,
            ),
          ),
        ]),
  );
}
