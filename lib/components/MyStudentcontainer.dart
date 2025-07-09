import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ohud/screens/StudentViewScreen.dart';

class Mystudentcontainer extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String tokenId;

  Mystudentcontainer({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.tokenId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: tokenId));
          Get.snackbar(
            "تم النسخ",
            "تم نسخ رقم الطالب إلى الحافظة",
            colorText: Colors.black,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
          );
        },
        child: Container(
          height: 120,
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
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentName, style: TextStyle(fontSize: 25)),
                  Spacer(),
                  Text("الرقم : $tokenId", style: TextStyle(fontSize: 15)),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap:
                    () => Get.to(
                      StudentViewScreen(studentId: int.parse(studentId),studentToken: int.parse(tokenId),),
                    ),
                child: Icon(
                  Iconsax.arrow_circle_left,
                  color: Color(0XFF049977),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
