import 'package:flutter/material.dart';

class MyNavigationDestination extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;

  const MyNavigationDestination({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Color(0xFF029B88) : Color(0xFFB3B3B3); // green vs gray

    return NavigationDestination(
      icon: SizedBox(
        width: MediaQuery.of(context).size.width/4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: color),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      label: '', // hide built-in label
    );
  }
}
