import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ohud/utils/EndPoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircleDataController extends GetxController {
  var isLoading = true.obs;

  var attendanceStats = <String, double>{}.obs;
  var teacherName = ''.obs;
  var rank = 0.obs;
  var studentsCount = 0.obs;
  var attendanceRatio = '0%'.obs;
  var circlesCount = 0.obs;

  var recitationCount = 0.obs;
  var recitationAvg = 0.0.obs;
  var sabrCount = 0.obs;
  var sabrAvg = 0.0.obs;

  var topOverall = <Map<String, dynamic>>[].obs;
  var topReciters = <Map<String, dynamic>>[].obs;
  var topSabrs = <Map<String, dynamic>>[].obs;
  var topAttendees = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) throw Exception("لم يتم العثور على التوكن");

      final response = await http.get(
        Uri.parse(APIEndpoints.baseUrl + APIEndpoints.teacherPoints.data),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.request);
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200 || response.body.isEmpty) {
        throw Exception("فشل في تحميل البيانات: ${response.statusCode}");
      }

      final data = jsonDecode(response.body);

      teacherName.value = data['teacherName'] ?? 'غير معروف';

      final stats = data['attendanceStats'] as Map<String, dynamic>?;
      if (stats != null) {
        attendanceStats.value = stats.map((key, value) {
          final ratio = (value['ratio'] as num?)?.toDouble() ?? 0.0;
          return MapEntry(key, ratio / 100);
        });
      }

      attendanceRatio.value =
          "${((attendanceStats['حضور'] ?? 0.0) * 100).toStringAsFixed(1)}%";

      recitationCount.value = data['recitationCount'] ?? 0;
      recitationAvg.value = (data['recitationAvg'] as num?)?.toDouble() ?? 0.0;
      sabrCount.value = data['sabrCount'] ?? 0;
      sabrAvg.value = (data['sabrAvg'] as num?)?.toDouble() ?? 0.0;

      rank.value = data['circleOverallRank'] ?? 0;
      circlesCount.value = data['circlesCount'] ?? 0;
      studentsCount.value =
          data['studentCount'] is int ? data['studentCount'] : 0;

      topOverall.value =
          (data['topOverall'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          [];
      topReciters.value =
          (data['topReciters'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          [];
      topSabrs.value =
          (data['topSabrs'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          [];
      topAttendees.value =
          (data['topAttendees'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          [];
    } catch (e, stack) {
      print("خطأ أثناء تحميل البيانات: $e\n$stack");
    } finally {
      isLoading.value = false;
    }
  }
}
