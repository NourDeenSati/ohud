import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AbsenceController.dart';
import 'package:ohud/controllers/QrControllers/AbsController.dart';
import 'package:ohud/screens/QRScreens/AbsQrScreen.dart';

class Absencescreen extends StatelessWidget {
  final AbsenceController controller = Get.put(
    AbsenceController(),
  ); // ← استخدام النسخة المُسجلة

  Absencescreen({super.key});
  FocusNode _node = FocusNode();
  final TextEditingController textController = TextEditingController();

  Future<void> scanQR() async {
    _node.requestFocus();
    await Get.to(
      () => const AbsQRViewExample(),
      binding: BindingsBuilder(() {
        Get.put(AbsQRScannerController());
      }),
    );
    textController.text = controller.studentId.value; // بعد العودة من المسح
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(title: '   تبرير غياب'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Student ID with QR Button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await scanQR();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
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
                    ),

                    Expanded(
                      child: TextField(
                        focusNode: _node,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text('رقم الطالب'),
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: ' أدخل رقم الطالب ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.keyboard),
                        ),
                        onChanged: controller.updateStudentId,
                        controller: textController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // تاريخ الغياب
                Obx(() {
                  final selectedDate = controller.absenceDate.value;
                  final formattedDate =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تاريخ الغياب:',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            // barrierColor: Color(0XFF000000),
                            context: context,
                            initialDate: controller.absenceDate.value,
                            firstDate: DateTime(2025),
                            lastDate: DateTime.now(),
                            locale: const Locale("ar", "SA"),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        Colors
                                            .teal, // اللون الأساسي (لون العنوان والسنة والأزرار)
                                    onPrimary:
                                        Colors
                                            .white, // لون النص فوق اللون الأساسي
                                    onSurface: Colors.black, // لون النص العادي
                                  ),
                                  dialogBackgroundColor:
                                      Colors.white, // خلفية نافذة التاريخ
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.updateAbsenceDate(picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF049977)),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 50),
                // Reason TextField
                TextField(
                  maxLines: 5,
                  onChanged: (val) => controller.reason.value = val,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    label: Text(' السبب'),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 50),

                // Register Button
                ElevatedButton(
                  // داخل onPressed:
                  onPressed: () {
                    if (controller.studentId.value.isEmpty ||
                        controller.reason.value.isEmpty ||
                        controller.absenceDate.value == null) {
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
                      middleText: "هل أنت متأكد من أنك تريد تسجيل هذا التبرير",
                      textConfirm: "نعم",
                      textCancel: "إلغاء",
                      confirmTextColor: Colors.white,
                      onConfirm: () async {
                        Get.back(); // إغلاق الـ Dialog

                        final success = await controller.submitAttendance();

                        if (success) {
                          controller.studentId.value = '';
                          controller.reason.value = '';
                          controller.absenceDate.value = DateTime.now();
                          Get.snackbar(
                            "تم التسجيل",
                            "الاسم: ${controller.studentId.value}\n"
                                "التاريخ: ${controller.absenceDate.value.toLocal().toString().split(' ')[0]}\n"
                                "المبرر: ${controller.reason.value}",
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 4),
                          );
                        } else {
                          // تم التعامل مع الخطأ داخل submitAttendance مسبقاً، لكن يمكنك إضافة Snackbar إضافي إن أحببت
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
