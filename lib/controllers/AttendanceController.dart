import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceController extends GetxController {
  var studentId = ''.obs;
  var attendanceType = '1'.obs;
  var isLoading = false.obs;

  void updateStudentId(String value) {
    studentId.value = value;
  }

  void updateAttendanceType(String type) {
    attendanceType.value = type;
  }

Future<bool> submitAttendance() async {
  isLoading.value = true;

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على التوكن");
      isLoading.value = false;
      return false;
    }

    final url = Uri.parse(
      APIEndpoints.baseUrl + APIEndpoints.attendanceEndPoint.submit,
    );

    final requestBody = {
      'student_token': studentId.value.trim(),
      'type': attendanceType.value,
    };

    print("Request URL: $url");
    print("Request Headers: {Authorization: Bearer $token, Content-Type: application/json}");
    print("Request Body: ${json.encode(requestBody)}");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final student = data['student'];
      final name = student['name'];
      final id = student['id'];
      final typeText = _getAttendanceTypeText(attendanceType.value);

      Get.snackbar(
        "تم تسجيل الحضور",
        "الاسم: $name\nالنوع: $typeText",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );

      return true;
    } else if (response.statusCode == 409) {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] ?? 'الطالب مسجل مسبقاً';
      Get.snackbar("تنبيه", message,);
      return false;
    } else {
      Get.snackbar("فشل", "فشل في إرسال الحضور");
      return false;
    }
  } catch (e) {
    print('حدث خطأ أثناء الإرسال: $e');
    Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال");
    return false;
  } finally {
    isLoading.value = false;
  }
}

String _getAttendanceTypeText(String type) {
  switch (type) {
    case '1':
      return 'حضور';
   
    case '4':
      return 'تأخير';
   
    default:
      return 'غير معروف';
  }
}
}