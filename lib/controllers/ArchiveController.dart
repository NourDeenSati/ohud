import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchiveController extends GetxController {
  var isLoading = true.obs;

  var recitations = [].obs;
  var attendances = [].obs;
  var notes = [].obs;

  String selectedType = 'الكل';
  final types = ['الكل', 'تسجيل صفحة', 'تسجيل حضور', 'تسجيل ملاحظة'];

  Future<void> fetchArchiveData() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        Uri.parse(APIEndpoints.baseUrl + APIEndpoints.teacherPoints.archive),
      );
      // print('Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      // print('Request URL: ${response.request?.url}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        recitations.value = List<Map<String, dynamic>>.from(
          data['recitations'] ?? [],
        );
        attendances.value = List<Map<String, dynamic>>.from(
          data['attendances'] ?? [],
        );
        notes.value = List<Map<String, dynamic>>.from(data['notes'] ?? []);
      } else {
        // Get.snackbar("خطأ", "فشل في جلب بيانات الأرشيف");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخادم");
    }

    isLoading.value = false;
  }

  List<Map<String, dynamic>> get filteredItems {
    List<Map<String, dynamic>> items = [];

    if (selectedType == 'الكل' || selectedType == 'تسجيل صفحة') {
      items.addAll(
        recitations.map(
          (e) => {
            'type': 'تسجيل صفحة',
            'student': e['student_name'] ?? 'غير معروف',
            'details': "${e['result'] ?? ''} - ${e['created_at'] ?? ''}",
          },
        ),
      );
    }

    if (selectedType == 'الكل' || selectedType == 'تسجيل حضور') {
      items.addAll(
        attendances.map(
          (e) => {
            'type': 'تسجيل حضور',
            'student': e['student_name'] ?? 'غير معروف',
            'details':
                "${e['attendance_type'] ?? ''} - ${e['created_at'] ?? ''}",
          },
        ),
      );
    }

    if (selectedType == 'الكل' || selectedType == 'تسجيل ملاحظة') {
      items.addAll(
        notes.map(
          (e) => {
            'type': 'تسجيل ملاحظة',
            'student': e['student_name'] ?? 'غير معروف',
            'details':
                "${e['note'] ?? 'بدون تفاصيل'} - ${e['created_at'] ?? ''}",
          },
        ),
      );
    }

    return items;
  }

  void changeFilter(String type) {
    selectedType = type;
    update(); // لتحديث الواجهة عند تغيير الفلتر
  }

  @override
  void onInit() {
    super.onInit();
    fetchArchiveData();
  }
}
