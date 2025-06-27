import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ohud/models/studentModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/endpoints.dart';

class CircleStudentsController extends GetxController {
  var isLoading = false.obs;
  var circle = ''.obs;
  var students = <StudentModel>[].obs;
  var searchQuery = ''.obs;

  Future<void> fetchCircleData() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("خطأ", "لم يتم العثور على التوكن");
        return;
      }

      final url = Uri.parse(
        APIEndpoints.baseUrl + APIEndpoints.teacherPoints.students,
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print(response.request);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = CircleWithStudentsModel.fromJson(jsonData);

        circle.value = model.circleName;
        students.assignAll(model.students);
      } else if (response.statusCode == 403) {
        // Get.snackbar("عذرا");
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء تحميل البيانات: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<StudentModel> get filteredStudents {
    if (searchQuery.isEmpty) return students;
    return students.where((s) =>
      s.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }
}
