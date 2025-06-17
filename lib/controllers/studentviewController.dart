// student_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ohud/utils/EndPoints.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StudentController extends GetxController {
  var isLoading = true.obs;
  var studentData = {}.obs;

  Future<void> fetchStudentData(int studentId) async {
    try {
        final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(APIEndpoints.baseUrl+APIEndpoints.teacherPoints.studentdata  +'$studentId/basic-info'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept' : 'application/json',
      },
      );
      print(response.request);
      print(response.body);
      if (response.statusCode == 200) {
        studentData.value = json.decode(response.body);
      } else {
        Get.snackbar("خطأ", "فشل في تحميل بيانات الطالب");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء الاتصال بالخادم");
    } finally {
      isLoading.value = false;
    }
  }
}
