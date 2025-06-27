import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyAttendancePieChart.dart';
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
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        return RefreshIndicator(
          color: Colors.teal,
          onRefresh: () async {
            await controller.fetchData();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // مخطط الحضور
              AttendancePieChart(data: controller.attendanceStats),

              // معلومات عامة
              Mystudentinfo(
                type: 'الترتيب:',
                info:
                    '${controller.rank.value} من ${controller.circlesCount.value}',
              ),
              // Mystudentinfo(
              //   type: 'عدد الطلاب:',
              //   info: controller.studentsCount.value.toString(),
              // ),
              Mystudentinfo(
                type: 'الصفحات المنجزة:',
                info: controller.recitationCount.value.toString(),
              ),
              Mystudentinfo(
                type: 'متوسط التقييم (تسميع):',
                info: controller.recitationAvg.value.toStringAsFixed(1),
              ),
              Mystudentinfo(
                type: 'عدد الأجزاء المسبورة:',
                info: controller.sabrCount.value.toString(),
              ),
              Mystudentinfo(
                type: 'متوسط تقييم السبر:',
                info: controller.sabrAvg.value.toStringAsFixed(1),
              ),

              const SizedBox(height: 30),

              // ترتيب الطلاب الإجمالي
              Text(
                'ترتيب الطلاب الإجمالي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              CustomScrollableBox(children: controller.topOverall),

              const SizedBox(height: 30),

              // ترتيب التسميع
              Text(
                'ترتيب الحلقة بالتسميع',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              CustomScrollableBox(children: controller.topReciters),

              const SizedBox(height: 30),

              // ترتيب السبر
              Text(
                'ترتيب الحلقة بالسبر',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              CustomScrollableBox(children: controller.topSabrs),

              const SizedBox(height: 30),

              // ترتيب الحضور
              Text(
                'ترتيب الحلقة بالحضور',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              CustomScrollableBox(children: controller.topAttendees),
            ],
          ),
        );
      }),
    );
  }
}

// صندوق تمرير لعرض التوب لست
class CustomScrollableBox extends StatelessWidget {
  final List<Map<String, dynamic>> children;

  const CustomScrollableBox({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Center(
      child: Container(
        width: 340,
        height: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children:
                    children.asMap().entries.map((entry) {
                      final index = entry.key;
                      final student = entry.value;

                      return _buildInnerBox(index, student);
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInnerBox(int index, Map<String, dynamic> student) {
    final name = student['name'] ?? 'غير معروف';
    final points = student['points']?.toString() ?? '0';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${index + 1}. $name',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(points, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
