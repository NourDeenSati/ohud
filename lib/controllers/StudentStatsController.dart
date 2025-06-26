import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ohud/models/studentStateModel.dart';
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentStatsController extends GetxController {
  var isLoading = true.obs;
  var stats = Rxn<StudentStatsModel>();

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      // الطلبان المتوازيان
      final weeklyUrl = Uri.parse(APIEndpoints.baseUrl + 'student/weekly');
      final rankingUrl = Uri.parse(APIEndpoints.baseUrl + 'student/rankings');

      final responses = await Future.wait([
        http.get(
          weeklyUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        http.get(
          rankingUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      ]);
      final weeklyResponse = responses[0];
      final rankingResponse = responses[1];
      print(weeklyResponse.request);
      print(weeklyResponse.body);
      print(weeklyResponse.statusCode);
      print(rankingResponse.statusCode);

      print(rankingResponse.request);
      print(rankingResponse.body);
      if (weeklyResponse.statusCode == 200 &&
          rankingResponse.statusCode == 200) {
        final weeklyJson = json.decode(weeklyResponse.body);
        final rankingJson = json.decode(rankingResponse.body);

        stats.value = StudentStatsModel.fromResponses(
          weeklyJson: weeklyJson,
          rankingsJson: rankingJson,
        );
      } else {
        Get.snackbar('خطأ', 'فشل في جلب البيانات');

      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب البيانات: $e');
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }
}
