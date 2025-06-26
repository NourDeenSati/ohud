import 'package:get/get.dart';

class PageRegisterController extends GetxController {
  // الحقول الرقمية
  var studentId = ''.obs;
  var pageNumber = ''.obs;
  void updateStudentId(String value) {
    studentId.value = value.trim();
  }
  void clearFields() {
    studentId.value = '';
    pageNumber.value = '';
  }
}
