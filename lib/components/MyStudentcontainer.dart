import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ohud/screens/StudentViewScreen.dart';

class Mystudentcontainer extends StatelessWidget {
  final String studentName;
  final String studentId;

   Mystudentcontainer({super.key, required this.studentName, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 80,
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
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName, style: TextStyle(fontSize: 25)),
                Text("الرقم : $studentId", style: TextStyle(fontSize: 15)),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () => Get.to(Studentviewscreen(studentId: int.parse(studentId),)),
              child: Icon(Iconsax.arrow_circle_left, color: Color(0XFF049977), size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
