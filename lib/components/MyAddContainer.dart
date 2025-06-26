import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAddContainer extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback onTap;        // ← بدل Widget page
  const MyAddContainer({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
        width: MediaQuery.of(context).size.width/5,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData, // استخدم الأيقونة القادمة من الكونستركتر
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 6),
              Text(
                text, // استخدم النص القادم من الكونستركتر
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
