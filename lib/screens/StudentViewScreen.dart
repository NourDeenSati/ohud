import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyStudentInfo.dart';
import 'package:ohud/components/MyStudentInfo2.dart';

class Studentviewscreen extends StatelessWidget {
  const Studentviewscreen({super.key, required int studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: ''),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Symbols.person_filled_rounded,
                  color: Color(0XFF000000),
                  size: 100,
                ),
                Text('أحمد محمد', style: TextStyle(fontSize: 40)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),

            child: Column(
              children: [
                Mystudentinfo(type: 'الرقم', info: "03255455"),

                Mystudentinfo(type: 'النقاط', info: "512"),

                Mystudentinfo(type: 'الترتيب على الحلقة', info: "2"),

                Mystudentinfo(type: 'الترتيب على المسجد', info: "5"),

                Mystudentinfo(type: 'التفقد :', info: " "),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Mystudentinfo2(type: "حضور", info: "10",color: Colors.teal,),
                    Mystudentinfo2(type: "تأخر", info: "2",color: const Color.fromARGB(255, 202, 202, 0),),
                    Mystudentinfo2(type: "غياب مبرر", info: "1",color: Colors.orange,),
                    Mystudentinfo2(type: "غياب", info: "0",color: Colors.red,),

                  ],
                ),
                   Mystudentinfo(type: 'التسميع :', info: " "),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Mystudentinfo2(type: "ممتاز", info: "10",color: Colors.teal,),
                    Mystudentinfo2(type: "جيد جداً", info: "2",color: const Color.fromARGB(255, 202, 202, 0),),
                    Mystudentinfo2(type: "جيد", info: "1",color: Colors.orange,),
                    Mystudentinfo2(type: "إعادة", info: "0",color: Colors.red,),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
