import 'package:get/get.dart';

class PageRegisterController extends GetxController {
  // الحقول الرقمية
  var studentId = ''.obs;
  var pageNumber = ''.obs;
  var mistake1 = 0.obs;
  var mistake2 = 0.obs;
  var mistake3 = 0.obs;

  // التقييم
  String get evaluation {
    int totalMistakes = mistake1.value + mistake2.value + mistake3.value;
    return totalMistakes == 0 ? 'ممتاز' : 'جيد';
  }

  void updateMistake(int index, String value) {
    int parsed = int.tryParse(value) ?? 0;
    if (index == 1) mistake1.value = parsed;
    if (index == 2) mistake2.value = parsed;
    if (index == 3) mistake3.value = parsed;
  }
}
