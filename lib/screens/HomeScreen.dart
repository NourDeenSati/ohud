import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ohud/components/MyAddContainer.dart';
import 'package:ohud/components/MyCarousel.dart';
import 'package:ohud/components/MyNavigationDestination.dart';
import 'package:ohud/components/MyStatsCard.dart';
import 'package:ohud/controllers/HomeController.dart';
import 'package:ohud/controllers/LogOutController.dart';
import 'package:ohud/controllers/carousel_controller.dart' as my_carousel;
import 'package:ohud/screens/AddNoteScreen.dart';
import 'package:ohud/screens/AddPageScreen.dart';
import 'package:ohud/screens/ArchiveScreen.dart';
import 'package:ohud/screens/AttendanceScreen.dart';
import 'package:ohud/screens/NotificationScreen.dart';
import 'package:ohud/screens/SignInScreen.dart';
import 'package:ohud/screens/StudentsScreen.dart';
import 'package:ohud/screens/absenceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final MycarouselController = Get.put(my_carousel.MyCarouselController());
  final logoutController = Get.put(LogoutController());
  final PageController pageController = PageController(viewportFraction: 0.7);
  final HomeController homeController = HomeController();

  Future<void> logout() async {
    logoutController.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Get.offAll(() => SigninScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => Get.to(SigninScreen()),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  logout();
                },
                child: Icon(Iconsax.logout, color: Color(0XFF049977)),
              ),
            ),
          ),
        ],
        title: Obx(
          () => Text(
            'الحلقة : ${controller.circleId.value}',
            style: TextStyle(
              color: Color(0XFF049977),
              fontSize: 25,
              fontFamily: "IBMPlexSansArabic",
            ),
          ),
        ),
        toolbarHeight: 80,
      ),
      body: Obx(
        () => IndexedStack(
          index:
              controller
                  .currentIndex
                  .value, // ← هذا يستخدم HomeController تلقائياً
          children: [
            _MainContent(),
            StudentsScreen(),
            Archivescreen(),
            NotificationsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        final selectedIndex = controller.currentIndex.value;
        return NavigationBar(
          height: 70,
          selectedIndex: selectedIndex,
          onDestinationSelected: controller.changePage,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: Colors.white,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Colors.transparent, width: 10),
          ),
          indicatorColor: Colors.transparent,
          destinations: [
            MyNavigationDestination(
              icon: Iconsax.home,
              label: 'الرئيسية',
              index: 0,
              selectedIndex: selectedIndex,
            ),
            MyNavigationDestination(
              icon: Iconsax.people,
              label: 'الطلاب',
              index: 1,
              selectedIndex: selectedIndex,
            ),
            MyNavigationDestination(
              icon: Iconsax.archive,
              label: 'الأرشيف',
              index: 2,
              selectedIndex: selectedIndex,
            ),
            MyNavigationDestination(
              icon: Iconsax.notification,
              label: 'الاشعارات',
              index: 3,
              selectedIndex: selectedIndex,
            ),
          ],
        );
      }),
    );
  }
}

class _MainContent extends StatelessWidget {
  _MainContent();
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                'مرحباً بك أستاذ ${homeController.userName.value} !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),

            // عرض الصور
            MyCarousel(),
            const SizedBox(height: 40),

            Row(
              children: [
                Icon(Iconsax.add_square, color: Color(0XFF049977)),
                SizedBox(width: 15),
                const Text(
                  'التسجيل :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyAddContainer(
                  text: 'قرآن',
                  iconData: Iconsax.book,
                  page: Addpagescreen(),
                ),
                MyAddContainer(
                  text: 'حضور',
                  iconData: Iconsax.card,
                  page: AttendanceScreen(),
                ),
                MyAddContainer(
                  text: 'ملاحظات',
                  iconData: Iconsax.note_text,
                  page: NoteScreen(),
                ),
                MyAddContainer(
                  text: 'تبرير غياب',
                  iconData: Iconsax.note_remove,
                  page: Absencescreen(),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Row(
              children: [
                Icon(Iconsax.status_up, color: Color(0XFF049977)),
                SizedBox(width: 15),

                const Text(
                  'احصائيات وبيانات :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 40),

            Mystatscard(),
          ],
        ),
      ),
    );
  }
}
