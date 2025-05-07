import 'package:get/get.dart';

class AttendanceController extends GetxController {
  var studentId = ''.obs;
  var AttendanceType = 'سلبية'.obs;

  void updateStudentId(String value) {
    studentId = value as RxString;
   
  }

  void updateAttendanceType(String type) {
    AttendanceType.value = type;
  }
}
