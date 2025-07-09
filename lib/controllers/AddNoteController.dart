import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ohud/utils/EndPoints.dart';

class NoteController extends GetxController {
  var studentId = ''.obs;
  var noteType = 'إيجابية'.obs;
  var reason = ''.obs;
  var isLoading = false.obs;

  void updateStudentId(String value) {
    studentId.value = value.trim();
  }

  void updateNoteType(String type) {
    noteType.value = type;
  }

  void updateReason(String value) {
    reason.value = value.trim();
  }

  void clearFields() {
    studentId.value = '';
    reason.value = '';
    noteType.value = 'إيجابية'; // إعادة إلى القيمة الافتراضية
  }

  Future<bool> submitNote() async {
  if (studentId.value.isEmpty || reason.value.length < 5) {
    Get.snackbar(
      "خطأ في البيانات",
      "يجب إدخال رقم الطالب، وتوضيح السبب بشكل كافٍ (5 أحرف على الأقل)",
       colorText: Colors.black,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
    );
    return false;
  }

  isLoading.value = true;

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar("خطأ", "لم يتم العثور على التوكن");
      return false;
    }

    final url = Uri.parse(APIEndpoints.baseUrl + APIEndpoints.notesEndPoint.submit);

    final body = {
      'student_token': studentId.value,
      'type': noteType.value == 'سلبية' ? 'negative' : 'positive',
      'reason': reason.value,
    };

    debugPrint("Request Body: $body");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json', // ✅ أضف هذا
      },
      body: jsonEncode(body),
    );

    debugPrint("Response Status: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}", wrapWidth: 1024);

    if (response.statusCode == 201) {

      clearFields();
      return true;
    } else {
      String msg = 'فشل في إرسال الملاحظة';
      try {
        final decoded = jsonDecode(response.body);
        msg = decoded['message'] ?? msg;
      } catch (e) {
        debugPrint("Decoding error: $e");
      }
      Get.snackbar("فشل", "",
      colorText: Colors.black);
      return false;
    }
  } catch (e) {
    debugPrint("Exception: $e");
    Get.snackbar("خطأ", "حدث خطأ أثناء الإرسال");
    return false;
  } finally {
    isLoading.value = false;
  }
}
}
