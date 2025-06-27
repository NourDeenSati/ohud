import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

class Myarchivecontainer extends StatelessWidget {
  Myarchivecontainer({
    super.key,
    required this.type,
    required this.student,
    required this.detailes,
  });
  final String type;
  final String student;
  final String detailes;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Color(0XFFFBFBFB),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // shadow color
              spreadRadius: 2, // how wide the shadow spreads
              blurRadius: 10, // how blurry the shadow is
              offset: Offset(0, 4), // shadow position: x, y
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: TextStyle(fontSize: 20)),
                Text(student, style: TextStyle(fontSize: 15)),
                Text(
                  detailes,
                  style: TextStyle(fontSize: 15, color: Colors.teal),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.archive, color: Colors.teal, size: 30),
          ],
        ),
      ),
    );
  }
}
