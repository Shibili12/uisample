import 'package:flutter/material.dart';

class Homecard extends StatelessWidget {
  String name;
  IconData icon;
  Color color;
  void Function() ontap;
  Homecard({
    required this.name,
    required this.color,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
            ),
            Text(
              name,
              style: TextStyle(color: Colors.blue[700]),
            ),
          ],
        ),
      ),
    );
  }
}
