import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenceController extends GetxController {
  var studentId = ''.obs;
  var reason = ''.obs;
  var absenceDate = DateTime.now().obs;
  var isLoading = false.obs;

  void updateStudentId(String value) {
    if (int.tryParse(value) != null) {
      studentId.value = value;
    }
  }

  void updateAbsenceDate(DateTime date) {
    absenceDate.value = date;
  }

  void clearFields() {
    studentId.value = '';
    reason.value = '';
    absenceDate.value = DateTime.now();
  }

  Future<bool> submitAttendance() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكن");
        return false;
      }

      final url = Uri.parse(
        APIEndpoints.baseUrl + APIEndpoints.attendanceEndPoint.abs,
      );

      final requestBody = {
        'student_token': studentId.value.trim(),
        'date': absenceDate.value.toString().split(' ')[0], // فقط التاريخ
        'justification': reason.value,
      };

      print("Request URL: $url");
      print(
        "Request Headers: {Authorization: Bearer $token, Content-Type: application/json}",
      );
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

        Get.snackbar(
          "تم إرسال الطالب بإنتظار موافقة الإدارة",
          "الاسم: $name\nالرقم: $id\nالتاريخ: ${absenceDate.value.toString().split(' ')[0]}",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor ?? null,
          colorText: Get.theme.snackBarTheme.actionTextColor ?? null,
        );

        clearFields(); // تفريغ الحقول
        return true;
      } else if (response.statusCode == 409 || response.statusCode == 404) {
        final responseBody = json.decode(response.body);
        final message = responseBody['message'] ?? 'حدث خطأ أثناء المعالجة';
        Get.snackbar(
          "تنبيه",
          message,
          backgroundColor: Get.theme.colorScheme.errorContainer,
          colorText: Get.theme.colorScheme.onErrorContainer,
        );
        return false;
      } else if (response.statusCode == 406) {
        final responseBody = json.decode(response.body);
        final message = responseBody['message'] ?? 'لا يمكن تقديم الطلب';
        Get.snackbar(
          "رفض التقديم",
          message,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }else if (response.statusCode == 422) {
        final responseBody = json.decode(response.body);
        final message =  'لا يمكن تقديم الطلب';
        Get.snackbar(
          "لا يوجد طالب بهذا الرقم !",
          message,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      } else {
        Get.snackbar("فشل", "فشل في إرسال الحضور: ${response.statusCode}");
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
}
