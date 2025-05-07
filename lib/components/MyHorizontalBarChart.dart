import 'package:flutter/material.dart';

class HorizontalBarChart extends StatelessWidget {
  final Map<String, double> data;
  
  const HorizontalBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // الأشرطة
          Row(
            children: data.entries.map((entry) {
              return Expanded(
                flex: (entry.value * 100).toInt(),
                child: Container(
                  height: 30,
                  color: _getColor(entry.key),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 10),
          
          // التسميات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.entries.map((entry) {
              return Expanded(
                flex: (entry.value * 100).toInt(),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 45,
                    child: Text(
                      "${(entry.value * 100).toInt()}% - ${entry.key}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                      
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColor(String label) {
    switch(label) {
      case 'الغياب غير المبرر': return Colors.red;
      case 'الغياب المبرر': return Colors.orange;
      case 'التأخر': return Colors.yellow;
      case 'الحضور': return Colors.green;
      default: return Colors.grey;
    }
  }
}
