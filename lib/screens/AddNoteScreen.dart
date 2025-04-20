import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AddNoteController.dart';
import 'package:ohud/screens/QRScreen.dart';

class NoteScreen extends StatelessWidget {
  final NoteController controller = Get.find(); // ← استخدام النسخة المُسجلة

  NoteScreen({super.key});
  FocusNode _node = FocusNode();
  void scanQR() async {
    await Get.to(() => const QRViewExample()); // ← استخدم Get.to
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(title: 'تسجيل ملاحظة'),
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
                      child: Obx(
                        () => TextField(
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
                          controller: TextEditingController(
                            text: controller.studentId.value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Note Type Radio Buttons
                Obx(
                  () => Row(
                    children: [
                      const Text(
                        'النوع :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Radio(
                        value: 'إيجابية',
                        groupValue: controller.noteType.value,
                        onChanged: (val) => controller.updateNoteType(val!),
                        activeColor: Colors.teal,
                      ),
                      const Text('إيجابية'),
                      const Spacer(),

                      Radio(
                        value: 'سلبية',
                        groupValue: controller.noteType.value,
                        onChanged: (val) => controller.updateNoteType(val!),
                        activeColor: Colors.red,
                      ),
                      const Text('سلبية'),
                      const Spacer(),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

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

                const Spacer(),

                // Register Button
                ElevatedButton(
                  // داخل onPressed:
                  onPressed: () {
                    if (controller.studentId.value.isEmpty ||
                        controller.noteType.value.isEmpty ||
                        controller.reason.value.isEmpty) {
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
                      middleText:
                          "هل أنت متأكد من أنك تريد تسجيل هذه الملاحظة؟",
                      textConfirm: "نعم",
                      textCancel: "إلغاء",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back(); // إغلاق الحوار

                        // تنفيذ عملية التسجيل هنا (مثلاً: إرسال البيانات إلى السيرفر)

                        Get.snackbar(
                          "تم التسجيل",
                          "تم تسجيل الملاحظة بنجاح",
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
