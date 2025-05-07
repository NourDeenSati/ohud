import 'package:flutter/material.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyHorizontalBarChart.dart';
import 'package:ohud/components/MyStudentInfo.dart';

class Circledatascreen extends StatelessWidget {
  const Circledatascreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'احصائيات الحلقة 1'),
      body: ListView(
        children: [
          Mystudentinfo(type: 'الأستاذ :', info: "محمد محمد"),
          Mystudentinfo(type: 'الترتيب:', info: "5/12"),
          Mystudentinfo(type: 'عدد الطلاب :', info: "20"),
          Mystudentinfo(type: 'نسبة الحضور :', info: "75%"),
          HorizontalBarChart(
            data:  {
              'الغياب غير المبرر': 0.05,
              'الغياب المبرر': 0.10,
              'التأخر': 0.10,
              'الحضور': 0.75,
            },
          ),
          Mystudentinfo(type: 'الصفحات المنجزة :', info: "130"),
          Mystudentinfo(type: '', info: ""),
          Mystudentinfo(type: '', info: ""),

          // استخدام المكون
          
        ],
      ),
    );
  }
}
