import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyStudentInfo.dart';
import 'package:ohud/components/MyStudentInfo2.dart';
import 'package:ohud/controllers/studentviewController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class StudentViewScreen extends StatelessWidget {
  final int studentId;
  final StudentController controller = Get.put(StudentController());
  // String _buildWhatsAppUrl(String phone, [String? message]) {
  //   final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
  //   final msg = Uri.encodeComponent(message ?? "السلام عليكم");
  //   return "https://wa.me/$cleanedPhone?text=$msg";
  // }

  // void _openWhatsApp(String phone) async {
  //   final url = _buildWhatsAppUrl(phone);

  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //   } else {
  //     Get.snackbar("خطأ", "لا يمكن فتح واتساب لهذا الرقم");
  //   }
  // }

  StudentViewScreen({super.key, required this.studentId}) {
    controller.fetchStudentData(studentId);
  }
  String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  // void _callNumber(String phone) async {
  //   final cleanedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
  //   final Uri url = Uri(scheme: 'tel', path: cleanedPhone);

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     Get.snackbar("خطأ", "لا يمكن فتح تطبيق الاتصال");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: ''),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.studentData;
        return ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(
                    Symbols.person_filled_rounded,
                    color: Color(0XFF000000),
                    size: 100,
                  ),
                  Text(
                    data['name'] ?? 'اسم غير معروف',
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      final phone = data['student_phone'] ?? '';
                      Clipboard.setData(ClipboardData(text: phone));
                      Get.snackbar(
                        "تم النسخ",
                        "تم نسخ رقم الطالب إلى الحافظة",
                        colorText: Colors.black,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Mystudentinfo(
                      type: 'رقم الهاتف',
                      info: data['student_phone'] ?? '',
                    ),
                  ),
                  Mystudentinfo(
                    type: 'النقاط',
                    info: data['points'].toString(),
                  ),
                  Mystudentinfo(
                    type: 'الترتيب على الحلقة',
                    info: data['rank_in_circle'].toString(),
                  ),
                  Mystudentinfo(
                    type: 'الترتيب على المسجد',
                    info: data['rank_in_mosque'].toString(),
                  ),

                  Mystudentinfo(
                    type: 'الملاحظات الإيجابية',
                    info: data['positive_notes'].toString(),
                  ),
                  Mystudentinfo(
                    type: 'الملاحظات السلبية',
                    info: data['negative_notes'].toString(),
                  ),
                  Mystudentinfo(
                    type: 'الصفحات المسمعة ',
                    info: data['recitations_count'].toString(),
                  ),
                  Mystudentinfo(
                    type: 'الأجزاء المسبورة ',
                    info: data['sabrs_count'].toString(),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
