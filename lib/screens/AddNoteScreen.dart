import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AddNoteController.dart';
import 'package:ohud/screens/QRScreen.dart';

class NoteScreen extends StatelessWidget {
  final NoteController controller = Get.put(NoteController());
  final TextEditingController textController = TextEditingController();
  final FocusNode _node = FocusNode();

  NoteScreen({super.key});

  Future<void> scanQR() async {
    _node.requestFocus();
    await Get.to(() => const QRViewExample());
    textController.text = controller.studentId.value;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(title: 'تسجيل ملاحظة'),
        body: SingleChildScrollView(
          child: SafeArea(
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
                        onTap: scanQR,
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
                        child: TextField(
                          controller: textController,
                          focusNode: _node,
                          keyboardType: TextInputType.number,
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
                    ],
                  ),

                  const SizedBox(height: 24),
                  // اختيار نوع الملاحظة
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

                  // حقل السبب
                  TextField(
                    maxLines: 5,
                    onChanged: (val) => controller.reason.value = val,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black),
                      label: const Text(' السبب'),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // زر تسجيل الملاحظة
                  ElevatedButton(
                    onPressed: () {
                      if (controller.studentId.isEmpty ||
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
                          Get.back();

                          // تنفيذ عملية التسجيل هنا (مثلاً: إرسال البيانات إلى السيرفر)

                          Get.snackbar(
                            "تم التسجيل",
                            "تم تسجيل الملاحظة بنجاح",
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2),
                          );

                          controller.studentId.value = '';
                          controller.noteType.value = '';
                          controller.reason.value = '';
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
      ),
    );
  }
}
