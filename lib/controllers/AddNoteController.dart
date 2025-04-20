import 'package:get/get.dart';

class NoteController extends GetxController {
  var studentId = ''.obs;
  var noteType = 'سلبية'.obs;
  var reason = ''.obs;

  void updateStudentId(String value) {
    if (int.tryParse(value) != null) {
      studentId.value = value;
    }
  }

  void updateNoteType(String type) {
    noteType.value = type;
  }
}
