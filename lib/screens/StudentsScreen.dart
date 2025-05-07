import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyStudentcontainer.dart';
import 'package:ohud/screens/AwkafNamesUpScreen.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(Awkafnamesupscreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                height: 50,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        ' ترشيح أسماء الأوقاف',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Icon(Symbols.mosque, color: Colors.teal),
                  ],
                ),
              ),
            ),
          ),
          Mystudentcontainer(),
          Mystudentcontainer(),
          Mystudentcontainer(),

          Mystudentcontainer(),
          Mystudentcontainer(),
          Mystudentcontainer(),

          Mystudentcontainer(),
          Mystudentcontainer(),
          Mystudentcontainer(),

          Mystudentcontainer(),
          Mystudentcontainer(),
          Mystudentcontainer(),
        ],
      ),
    );
  }
}
