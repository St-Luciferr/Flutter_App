import 'package:flutter/material.dart';

Widget formattedDetails(String label, String text) {
  return RichText(
    textAlign: TextAlign.justify,
    text: TextSpan(
        text: label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Color.fromARGB(255, 80, 80, 80),
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ]),
  );
}
