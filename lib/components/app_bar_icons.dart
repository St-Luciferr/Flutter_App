import 'package:flutter/material.dart';

Widget createIcon(IconData iconName) {
  return Container(
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
      icon: Icon(iconName),
      onPressed: () {},
    ),
  );
}

class CustomIcon extends StatelessWidget {
  final IconData iconData;
  String tooltip;
  void Function()? actionFunction;
  CustomIcon({
    super.key,
    required this.iconData,
    required this.actionFunction,
    required this.tooltip,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
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
        icon: Icon(iconData),
        onPressed: actionFunction,
      ),
    );
  }
}
