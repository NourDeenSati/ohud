import 'package:get/get.dart';

class NoteController extends GetxController {
  var studentId = ''.obs;
  var noteType = 'سلبية'.obs;
  var reason = ''.obs;

 void updateStudentId(String value) {
    studentId = value as RxString;
   
  }


  void updateNoteType(String type) {
    noteType.value = type;
  }
}
