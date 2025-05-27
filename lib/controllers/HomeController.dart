import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  var circleId = 0.obs;
  var token = ''.obs;
  var userId = 0.obs;
  var userName = ''.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    circleId.value = prefs.getInt('circle_id') ?? 0;
    token.value = prefs.getString('token') ?? '';
    userId.value = prefs.getInt('user_id') ?? 0;
    userName.value = prefs.getString('user_name') ?? '';
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
