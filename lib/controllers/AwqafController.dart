import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AwqafController extends GetxController {
  var isLoading = false.obs;

  Future<void> nominateStudent(int studentToken, List<int> juzList) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('${APIEndpoints.baseUrl}teacher/awqaf/nominate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'student_token': studentToken.toString(),
          'juz': juzList,
        }),
      );
      if (response.statusCode == 201) {
        // تم الترشيح بنجاح
        final data = jsonDecode(response.body);
        Get.snackbar('نجاح', data['message'], snackPosition: SnackPosition.TOP);
      } else {
        // خطأ في الاستجابة
        Get.snackbar(
          'خطأ',
          'فشل في ترشيح الطالب',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ: $e', snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }
}
