import 'package:get/get.dart';

class AbsenceController extends GetxController {
  var studentId = ''.obs;
  var reason = ''.obs;
  var absenceDate = DateTime.now().obs;

  void updateStudentId(String value) {
    if (int.tryParse(value) != null) {
      studentId.value = value;
    }
  }

  void updateAbsenceDate(DateTime date) {
    absenceDate.value = date;
  }
}
