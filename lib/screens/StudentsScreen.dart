import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyStudentcontainer.dart';
import 'package:ohud/controllers/circleController.dart';
import 'package:ohud/screens/AwkafNamesUpScreen.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CircleStudentsController controller = Get.put(
      CircleStudentsController(),
    );

    // تحميل البيانات عند بناء الصفحة
    controller.fetchCircleData();

    return Scaffold(
      body: Obx(() {
        // عرض حالة التحميل
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Colors.teal));
        }

        // تحقق من وجود طلاب
        if (controller.students.isEmpty) {
          return Center(
            child: Text(
              'لم يتم إضافة طلاب',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }

        return RefreshIndicator(
          color: Colors.teal,
          onRefresh: () async {
            await controller.fetchCircleData();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // GestureDetector(
              //   onTap: () {
              //     Get.to(Awkafnamesupscreen());
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(18.0),
              //     child: Container(
              //       height: 50,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(color: Colors.teal),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(left: 12.0),
              //             child: Text(
              //               'ترشيح أسماء الأوقاف',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 20,
              //               ),
              //             ),
              //           ),
              //           Icon(Symbols.mosque, color: Colors.teal),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // عرض الطلاب باستخدام Mystudentcontainer
              for (var entry in controller.students)
                Mystudentcontainer(
                  studentName: entry.name,
                  studentId: entry.id.toString(),
                  tokenId: entry.tokenId,
                ),
            ],
          ),
        );
      }),
    );
  }
}

class CustomScrollableBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xF5F7FBFF), // لون فاتح جداً للخلفية
          borderRadius: BorderRadius.circular(20),
        ),
        child: Scrollbar(
          thumbVisibility: true, // لإظهار مؤشر السكروول
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(5, (index) => _buildInnerBox()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInnerBox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
