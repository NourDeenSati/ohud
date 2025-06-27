import 'package:flutter/material.dart';

class CustomScrollableBox extends StatelessWidget {
  final List<Map<String, dynamic>> children;

  const CustomScrollableBox({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Center(
      child: Container(
        width: 340,
        height: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 250, 255, 255),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children:
                    children.asMap().entries.map((entry) {
                      final index = entry.key;
                      final student = entry.value;

                      return _buildInnerBox(index, student);
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInnerBox(int index, Map<String, dynamic> student) {
    final name = student['name'] ?? 'غير معروف';
    final points = student['points']?.toString() ?? '0';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${index + 1}. $name',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(points, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}
