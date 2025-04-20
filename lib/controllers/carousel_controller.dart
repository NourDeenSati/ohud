import 'package:get/get.dart';

class MyCarouselController extends GetxController {
  var currentIndex = 0.obs;

  List<String> imagePaths = [
    'assets/images/1.png',
    'assets/images/1.png',
    'assets/images/1.png',
  ];

  void setCurrentIndex(int index) {
    currentIndex.value = index;
    update(); // لتحديث GetBuilder
  }
}
