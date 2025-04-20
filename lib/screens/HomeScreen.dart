import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ohud/components/MyAddContainer.dart';
import 'package:ohud/components/MyCarousel.dart';
import 'package:ohud/components/MyNavigationDestination.dart';
import 'package:ohud/components/MyStatsCard.dart';
import 'package:ohud/controllers/HomeController.dart';
import 'package:ohud/controllers/carousel_controller.dart' as my_carousel;
import 'package:ohud/screens/AddNoteScreen.dart';
import 'package:ohud/screens/AddPageScreen.dart';
import 'package:ohud/screens/AttendanceScreen.dart';
import 'package:ohud/screens/NotificationScreen.dart';
import 'package:ohud/screens/SettingsScreen.dart';
import 'package:ohud/screens/StudenstScreen.dart';
import 'package:ohud/screens/absenceScreen.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final MycarouselController = Get.put(my_carousel.MyCarouselController());
  final PageController pageController = PageController(viewportFraction: 0.7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الحلقة : 1',
          style: TextStyle(
            color: Color(0XFF049977),
            fontSize: 25,
            fontFamily: "IBMPlexSansArabic",
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
            NotificationsScreen(),
            Settingsscreen(),
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
  HomeController homeController = HomeController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مرحباً بك أستاذ محمد !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // عرض الصور
            MyCarousel(),
            const SizedBox(height: 40),

            Row(
              children: [
                const Text(
                  'التسجيل :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Iconsax.add_square, color: Color(0XFF049977)),
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
                const Text(
                  'احصائيات وبيانات :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Iconsax.status_up, color: Color(0XFF049977)),
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
