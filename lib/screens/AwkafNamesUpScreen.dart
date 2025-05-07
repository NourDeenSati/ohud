import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AwkafController.dart';

class Awkafnamesupscreen extends StatelessWidget {
  Awkafnamesupscreen({super.key});
  final StudentController controller = Get.put(StudentController());

  DateTime getLastSaturdayOfThisMonth() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    while (lastDayOfMonth.weekday != DateTime.saturday) {
      lastDayOfMonth = lastDayOfMonth.subtract(Duration(days: 1));
    }

    return lastDayOfMonth;
  }

  void _confirmAndClearStudents(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            content: Text("هل أنت متأكد أنك تريد ترشيح الطلاب ومسح القائمة؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // إلغاء
                child: Text("إلغاء"),
              ),
              TextButton(
                onPressed: () {
                  controller.clearAllStudents();
                  Navigator.pop(context);
                  Get.snackbar(
                    "تم",
                    "تم ترشيح الطلاب ومسح القائمة",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Text("تأكيد"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastSaturday = getLastSaturdayOfThisMonth();
    String formattedDate =
        "${lastSaturday.year}-${lastSaturday.month.toString().padLeft(2, '0')}-${lastSaturday.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: MyAppBar(title: ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'قم بإضافة الطلاب الراغبين بالترشح لسبر الأوقاف القادم :',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'تاريخ السبر: $formattedDate',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.students.length,
                itemBuilder: (context, index) {
                  final student = controller.students[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: student.nameController,
                            decoration: InputDecoration(
                              labelText: 'اسم الطالب',
                            ),
                            onChanged:
                                (_) => controller.addStudentIfLastFilled(index),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: student.partController,
                            decoration: InputDecoration(labelText: 'رقم الجزء'),
                            keyboardType: TextInputType.number,
                            onChanged:
                                (_) => controller.addStudentIfLastFilled(index),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // زر الترشيح في أسفل الشاشة
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.teal,
            textStyle: TextStyle(fontSize: 18),
          ),
          onPressed: () => _confirmAndClearStudents(context),
          child: Text('ترشيح'),
        ),
      ),
    );
  }
}
