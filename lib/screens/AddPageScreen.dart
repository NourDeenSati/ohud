import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/controllers/AddPageController.dart';

class Addpagescreen extends StatelessWidget {
  final controller = Get.put(PageRegisterController());

  Addpagescreen({super.key});

  Widget buildTextField(String hint, RxString value) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: Icon(Symbols.format_list_numbered_rtl),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onChanged: (val) => value.value = val,
    );
  }

  Widget buildMistakeField(int index, String label) {
    return SizedBox(
      width: 90,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (val) => controller.updateMistake(index, val),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:MyAppBar(title: 'تسجيل صفحة') 
      ,      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              buildTextField('أدخل رقم الطالب', controller.studentId),
              const SizedBox(height: 12),
              buildTextField('أدخل رقم الصفحة', controller.pageNumber),
              const SizedBox(height: 20),
              const Text('الأخطاء'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildMistakeField(1, 'حفظ'),
                  buildMistakeField(2, 'تجويد'),
                  buildMistakeField(3, 'تشكيل'),
                ],
              ),
              const SizedBox(height: 20),
              const Text('التقييم'),
              const SizedBox(height: 10),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Text(
                    controller.evaluation,
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          controller.evaluation == 'ممتاز'
                              ? Colors.teal
                              : Colors.orange,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // تنفيذ عملية التسجيل
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
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
    );
  }
}
