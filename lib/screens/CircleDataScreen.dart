import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyHorizontalBarChart.dart';
import 'package:ohud/components/MyStudentInfo.dart';
import 'package:ohud/controllers/CircleDataController.dart';

class CircleDataScreen extends StatelessWidget {
  final controller = Get.put(CircleDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'احصائيات الحلقة'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // if (controller.errorMessage.isNotEmpty) {
        //   return Center(child: Text(controller.errorMessage.value));
        // }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Mystudentinfo(type: 'الأستاذ :', info: controller.teacherName.value),
            Mystudentinfo(type: 'الترتيب:', info: controller.rank.value),
            Mystudentinfo(type: 'عدد الطلاب :', info: controller.studentsCount.toString()),
            Mystudentinfo(type: 'نسبة الحضور :', info: controller.attendanceRatio.value),
            HorizontalBarChart(data: controller.attendanceStats),
            Mystudentinfo(type: 'الصفحات المنجزة :', info: controller.recitationCount.toString()),

            const SizedBox(height: 16),
            Text('ترتيب الطلاب الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomScrollableBox(children: controller.topOverall),

            const SizedBox(height: 16),
            Text('أفضل المقرئين', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomScrollableBox(children: controller.topReciters),

            const SizedBox(height: 16),
            Text('أفضل الصابرين', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomScrollableBox(children: controller.topSabrs),

            const SizedBox(height: 16),
            Text('أفضل الحضور', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomScrollableBox(children: controller.topAttendees),
          ],
        );
      }),
    );
  }
}

class CustomScrollableBox extends StatelessWidget {
  final List<Map<String, dynamic>> children;

  const CustomScrollableBox({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xF5F7FBFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              children: children.map(_buildInnerBox).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInnerBox(Map<String, dynamic> student) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold)),
          Text(student['points'].toString(), style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
