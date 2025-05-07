import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:ohud/screens/HomeScreen.dart';
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SigninController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var obscure = true.obs;

  void toggleObscure() => obscure.value = !obscure.value;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> login() async {
    // if (username.isEmpty || password.isEmpty) {
    //     Get.snackbar("تنبيه", "يرجى إدخال جميع الحقول",colorText:Colors.black);
    //    } 
    //   if (username.isEmpty || password.isEmpty) {
    //     Get.snackbar("تنبيه", "يرجى إدخال جميع الحقول",colorText:Colors.black);
    //   } else {
    //     // منطق تسجيل الدخول
    //     Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح",colorText: Colors.black);
    //     Get.to(HomeScreen());
    //   }

    var headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};
    try {
      var url = Uri.parse(
        APIEndpoints.baseUrl + APIEndpoints.authEndPoint.login,
      );

      Map body = {
        'name': usernameController.text.trim(),
        'password': passwordController.text,
      };
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
              print("response name is : >>>>> ${response.body}");
          print(body);
      if (response.statusCode == 200) {
                  Get.to(HomeScreen());

        final json = jsonDecode(response.body);
        if (json['code'] == 0) {
          var token = json['data']['Token'];
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);

          usernameController.clear();
          passwordController.clear();
        } else {
          throw jsonDecode(response.body)["Message"] ?? "error Occured";
        }
      }
    } catch (error) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: Text("Error"),
            contentPadding: EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}
