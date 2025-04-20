import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AttendanceController.dart';
import 'package:ohud/screens/QRScreen.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceController controller =
      Get.find(); // ← استخدام النسخة المُسجلة
  final TextEditingController textController = TextEditingController();

  AttendanceScreen({super.key});
  FocusNode _node = FocusNode();
  void scanQR() async {
    await Get.to(() => const QRViewExample()); // ← استخدم Get.to
  }

  @override
  Widget build(BuildContext context) {
    textController.text = controller.studentId.value;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(title: '  تسجيل حضور'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Student ID with QR Button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _node.requestFocus();
                        scanQR();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Symbols.qr_code_scanner,
                          color: Color(0xFF00695C),
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Expanded(
                        child: TextField(
                          focusNode: _node,
                          keyboardType: TextInputType.number,
                          controller: textController,
                          onChanged: (val) => controller.updateStudentId(val),
                          decoration: InputDecoration(
                            label: Text('رقم الطالب'),
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: ' أدخل رقم الطالب ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: const Icon(Icons.keyboard),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Note Type Radio Buttons
                Obx(() {
                  final now = DateTime.now();
                  final arabicWeekdays = {
                    1: 'الاثنين',
                    2: 'الثلاثاء',
                    3: 'الأربعاء',
                    4: 'الخميس',
                    5: 'الجمعة',
                    6: 'السبت',
                    7: 'الأحد',
                  };
                  final dayName = arabicWeekdays[now.weekday] ?? '';
                  final formattedDate =
                      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      Center(
                        child: Text(
                          ' $dayName - $formattedDate',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 30),
                      const Text(
                        'النوع :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Spacer(),
                          Radio(
                            value: 'حضور',
                            groupValue: controller.AttendanceType.value,
                            onChanged:
                                (val) => controller.updateAttendanceType(val!),
                            activeColor: Colors.teal,
                          ),
                          const Text('حضور'),
                          const Spacer(),
                          Radio(
                            value: 'تأخر',
                            groupValue: controller.AttendanceType.value,
                            onChanged:
                                (val) => controller.updateAttendanceType(val!),
                            activeColor: Colors.red,
                          ),
                          const Text('تأخر'),
                          const Spacer(),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 12),

                const Spacer(),

                // Register Button
                ElevatedButton(
                  // داخل onPressed:
                  onPressed: () {
                    if (controller.studentId.value.isEmpty ||
                        controller.AttendanceType.value.isEmpty) {
                      Get.snackbar(
                        "تحذير",
                        "يرجى تعبئة جميع الحقول قبل التسجيل",
                        backgroundColor: Colors.orange.shade100,
                        colorText: Colors.black,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    Get.defaultDialog(
                      title: "تأكيد التسجيل",
                      middleText: "هل أنت متأكد من أنك تريد تسجيل الحضور؟",
                      textConfirm: "نعم",
                      textCancel: "إلغاء",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back(); // إغلاق الحوار

                        // تنفيذ عملية التسجيل هنا (مثلاً: إرسال البيانات إلى السيرفر)

                        Get.snackbar(
                          "تم التسجيل",
                          "تم تسجيل الحضور بنجاح",
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.black,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );

                        // يمكنك إعادة تعيين الحقول إذا أردت:
                        // controller.studentId.value = '';
                        // controller.noteType.value = '';
                        // controller.reason.value = '';
                      },
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('تسجيل'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
