import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/screens/CircleDataScreen.dart';

class Mystatscard extends StatelessWidget {
  const Mystatscard({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 380,
        height: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'احصائيات الحلقة : 1',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                GestureDetector(onTap: () {
                  Get.to(CircleDataScreen());
                },child: Icon(Icons.arrow_circle_left_rounded,color: Color(0XFF169B88),size: 28,)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  InfoTile(icon: Icons.person, text: 'الأستاذ: أحمد أحمد'),
                  InfoTile(icon: Icons.group, text: '20 طالب'),
                  InfoTile(icon: Icons.bubble_chart, text: 'نسبة الحضور : %70'),
                  InfoTile(icon: Icons.menu, text: 'الصفحات المنجزة : 130'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
          ),
          Icon(icon, color: Colors.teal),
        ],
      ),
    );
  }
}
