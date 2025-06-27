import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyStudentcontainer.dart';
import 'package:ohud/controllers/circleController.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({super.key});
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CircleStudentsController controller = Get.put(
      CircleStudentsController(),
    );

    controller.fetchCircleData();

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        if (controller.students.isEmpty) {
          return const Center(
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
            padding: const EdgeInsets.all(5),
            children: [
              // 🔍 حقل البحث
              Obx(
                () => TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم الطالب',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon:
                        controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                textController.clear(); // يمسح النص من الحقل
                                controller.searchQuery.value =
                                    ''; // يعيد القائمة الأصلية
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value.trim();
                  },
                ),
              ),

              const SizedBox(height: 16),

              // عرض الطلاب المصفّاة
              for (var entry in controller.filteredStudents)
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
