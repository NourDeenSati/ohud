import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AddPageController.dart';
import 'package:ohud/controllers/QrControllers/pageQrController.dart';
import 'package:ohud/mushaf/views/one_page_view.dart';
import 'package:ohud/screens/QRScreens/pageQrScreen.dart';

class Addpagescreen extends StatelessWidget {
  final controller = Get.put(PageRegisterController());
  final TextEditingController textController = TextEditingController();
  final FocusNode _node = FocusNode();

  Addpagescreen({super.key});

  Future<void> scanQR() async {
    _node.requestFocus();
    await Get.to(
      () => const PageQRViewExample(),
      binding: BindingsBuilder(() {
        Get.put(PageQRScannerController());
      }),
    );
    textController.text = controller.studentId.value;
    controller.updateStudentId(
      controller.studentId.value,
    ); // ✅ مهم لتحديث القيمة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'تسجيل صفحة'),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                    child: TextField(
                      controller: textController,
                      focusNode: _node,
                      keyboardType: TextInputType.number,
                      onChanged:
                          (val) => controller.updateStudentId(
                            val,
                          ), // ✅ مهم لتحديث القيمة
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

              const SizedBox(height: 40),

              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val) => controller.pageNumber.value = val,
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Iconsax.book,),

                    labelStyle: const TextStyle(color: Colors.black),
                    label: const Text(' الصفحة'),
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1,),
              ElevatedButton(
                onPressed: () {
                  if (controller.studentId.value.isEmpty ||
                      controller.pageNumber.value.isEmpty) {
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
                  Get.to(
                    OnePageView(
                      pageNumber: int.parse(controller.pageNumber.value),
                      studentId: controller.studentId.value,
                    ),
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
              Spacer(flex: 2,),
            ],
          ),
        ),
      ),
    );
  }
}
