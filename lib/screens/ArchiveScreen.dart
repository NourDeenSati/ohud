import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ohud/components/MyArchiveContainer.dart';
import 'package:ohud/controllers/ArchiveController.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ArchiveController controller = Get.put(ArchiveController(),permanent: true);

    return Scaffold(
      body: GetBuilder<ArchiveController>(
        builder: (_) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal,));
          }

          return Column(
            children: [
              // فلتر أنيق
              Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.types.map((type) {
                    final isSelected = controller.selectedType == type;
                    return ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: Colors.teal,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) => controller.changeFilter(type),
                    );
                  }).toList(),
                ),
              ),

              // عرض النتائج
              Expanded(
                child: controller.filteredItems.isEmpty
                    ? const Center(child: Text('لا توجد سجلات للعرض'))
                    : ListView.builder(
                        itemCount: controller.filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredItems[index];
                          return Myarchivecontainer(
                            type: item['type'],
                            student: item['student'],
                            detailes: item['details'], // تأكد أن الكلمة هي "detailes" هنا إذا كان المكون يتطلبها كذلك
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
