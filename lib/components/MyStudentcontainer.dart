import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ohud/screens/StudentsScreen.dart';
import 'package:ohud/screens/StudentViewScreen.dart';



class Mystudentcontainer extends StatelessWidget {
  const Mystudentcontainer({super.key});




  @override
  Widget build(BuildContext context) {
    return    Padding(
            padding: const EdgeInsets.all(15),
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
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('أحمد محمد', style: TextStyle(fontSize: 25)),
                      Text('02150', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Get.to(Studentviewscreen()),
                    child: Icon(Iconsax.arrow_circle_left,color: Color(0XFF049977),size: 30,))

                ],
              ),
            ),
          )
;
  }
}