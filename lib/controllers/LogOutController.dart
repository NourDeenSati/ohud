import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ohud/screens/SigninScreen.dart';

class LogoutController extends GetxController {
  var isLoading = false.obs;

  Future<void> logout() async {
    isLoading.value = true;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("خطأ", "المستخدم غير مسجل دخول", colorText: Get.theme.colorScheme.error);
        isLoading.value = false;
        return;
      }

      var url = Uri.parse(APIEndpoints.baseUrl + APIEndpoints.authEndPoint.logout);

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
print(response.body);
      final json = jsonDecode(response.body);
      print("Logout response: $json");

      if (response.statusCode == 200 && json["message"] != null) {
        await prefs.remove('token');
        await prefs.setBool('isLoggedIn', false);
        Get.offAll(() => SigninScreen());
        Get.snackbar("تم", json["message"], colorText: Get.theme.primaryColor);
      } else {
        Get.snackbar("خطأ", "فشل تسجيل الخروج", colorText: Get.theme.colorScheme.error);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ: $e", colorText: Get.theme.colorScheme.error);
    } finally {
      isLoading.value = false;
    }
  }
}
