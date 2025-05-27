import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AttendanceController.dart';
import 'package:ohud/controllers/QrControllers/AttenQRController.dart';
import 'package:ohud/screens/QRScreens/AttenQRScreen.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceController controller = Get.put(
    AttendanceController(),
    permanent: false,
  );
  final TextEditingController textController = TextEditingController();
  final FocusNode _node = FocusNode();

  AttendanceScreen({super.key});

  Future<void> scanQR() async {
    _node.requestFocus();
    await Get.to(
      () => const AttenQRViewExample(),
      binding: BindingsBuilder(() {
        Get.put(AttenQRScannerController());
      }),
    );
    textController.text = controller.studentId.value; // تحديث الحقل بعد العودة
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(title: 'تسجيل حضور'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // حقل رقم الطالب + زر QR
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await scanQR();
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
                      child: Obx(
                        () => TextField(
                          focusNode: _node,
                          keyboardType: TextInputType.number,
                          controller: textController
                            ..text = controller.studentId.value
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.studentId.value.length),
                            ),
                          onChanged: (value) => controller.updateStudentId(value),
                          decoration: InputDecoration(
                            label: const Text('رقم الطالب'),
                            labelStyle: const TextStyle(color: Colors.black),
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

                // اختيار النوع
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
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          ' $dayName - $formattedDate',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'النوع :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Spacer(),
                          Radio(
                            value: '1',
                            groupValue: controller.attendanceType.value,
                            onChanged: (val) =>
                                controller.updateAttendanceType('1'),
                            activeColor: Colors.teal,
                          ),
                          const Text('حضور'),
                          const Spacer(),
                          Radio(
                            value: '4',
                            groupValue: controller.attendanceType.value,
                            onChanged: (val) =>
                                controller.updateAttendanceType('4'),
                            activeColor: Colors.red,
                          ),
                          const Text('تأخر'),
                          const Spacer(),
                        ],
                      ),
                    ],
                  );
                }),

                const Spacer(),

                // زر التسجيل
                ElevatedButton(
                  onPressed: () {
                    if (controller.studentId.value.isEmpty ||
                        controller.attendanceType.value.isEmpty) {
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
                      onConfirm: () async {
                        Get.back(); // إغلاق النافذة

                        final success = await controller.submitAttendance();

                        if (success) {
                          Get.snackbar(
                            "تم التسجيل",
                            "تم تسجيل الحضور بنجاح",
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                          );
                          controller.studentId.value = '';
                          textController.clear();
                        }
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
