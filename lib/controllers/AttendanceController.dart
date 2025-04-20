import 'package:get/get.dart';

class AttendanceController extends GetxController {
  var studentId = ''.obs;
  var AttendanceType = 'سلبية'.obs;

  void updateStudentId(String value) {
    if (int.tryParse(value) != null) {
      studentId.value = value;
    }
  }

  void updateAttendanceType(String type) {
    AttendanceType.value = type;
  }
}
