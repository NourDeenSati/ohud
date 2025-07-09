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
      if (token == null) throw Exception("❌ لم يتم العثور على التوكن");

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      /// -------------------- Get Top Rankings --------------------
      final topRes = await http.get(
        Uri.parse('${APIEndpoints.baseUrl}teacher/circle/top'),
        headers: headers,
      );
      print("📦 [Top Rankings] Status: ${topRes.statusCode}");
      print("📦 [Top Rankings] Body:\n${topRes.body}");

      if (topRes.statusCode == 200) {
        final topData = jsonDecode(topRes.body);
        topOverall.value = (topData['topOverall'] as List).cast<Map<String, dynamic>>();
        topReciters.value = (topData['topReciters'] as List).cast<Map<String, dynamic>>();
        topSabrs.value = (topData['topSabrs'] as List).cast<Map<String, dynamic>>();
        topAttendees.value = (topData['topAttendees'] as List).cast<Map<String, dynamic>>();
      }

      /// -------------------- Get Attendance Stats --------------------
      final attRes = await http.get(
        Uri.parse('${APIEndpoints.baseUrl}teacher/circle/attendance'),
        headers: headers,
      );
      print("📦 [Attendance Stats] Status: ${attRes.statusCode}");
      print("📦 [Attendance Stats] Body:\n${attRes.body}");

      if (attRes.statusCode == 200) {
        final attData = jsonDecode(attRes.body);
        final stats = attData['attendanceStats'] as Map<String, dynamic>;
        attendanceStats.value = stats.map((key, value) {
          final ratio = (value['ratio'] as num?)?.toDouble() ?? 0.0;
          return MapEntry(key, ratio / 100);
        });
        attendanceRatio.value =
            "${((attendanceStats['حضور'] ?? 0.0) * 100).toStringAsFixed(1)}%";
      }

      /// -------------------- Get Rankings --------------------
      final rankRes = await http.get(
        Uri.parse('${APIEndpoints.baseUrl}teacher/circle/rankings'),
        headers: headers,
      );
      print("📦 [Rankings] Status: ${rankRes.statusCode}");
      print("📦 [Rankings] Body:\n${rankRes.body}");

      if (rankRes.statusCode == 200) {
        final rankData = jsonDecode(rankRes.body);
        rank.value = rankData['circleOverallRank'] ?? 0;
        circlesCount.value = rankData['circlesCount'] ?? 0;
      }

      /// -------------------- Get Recitations --------------------
      final recRes = await http.get(
        Uri.parse('${APIEndpoints.baseUrl}teacher/circle/recitations'),
        headers: headers,
      );
      print("📦 [Recitations] Status: ${recRes.statusCode}");
      print("📦 [Recitations] Body:\n${recRes.body}");

      if (recRes.statusCode == 200) {
        final recData = jsonDecode(recRes.body);
        recitationCount.value = recData['recitationCount'] ?? 0;
        recitationAvg.value =
            (recData['recitationAvg'] as num?)?.toDouble() ?? 0.0;
      }

      /// -------------------- Get Sabrs --------------------
      final sabrRes = await http.get(
        Uri.parse('${APIEndpoints.baseUrl}teacher/circle/sabrs'),
        headers: headers,
      );
      print("📦 [Sabrs] Status: ${sabrRes.statusCode}");
      print("📦 [Sabrs] Body:\n${sabrRes.body}");

      if (sabrRes.statusCode == 200) {
        final sabrData = jsonDecode(sabrRes.body);
        sabrCount.value = sabrData['sabrCount'] ?? 0;
        sabrAvg.value = (sabrData['sabrAvg'] as num?)?.toDouble() ?? 0.0;
      }

    } catch (e, stack) {
      print("❌ خطأ أثناء تحميل البيانات: $e\n$stack");
    } finally {
      isLoading.value = false;
    }
  }
}
