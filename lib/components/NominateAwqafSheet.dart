import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ohud/controllers/AwqafController.dart';

class NominateAwqafSheet extends StatefulWidget {
  final int studentToken;
  const NominateAwqafSheet({Key? key, required this.studentToken}) : super(key: key);
  @override
  _NominateAwqafSheetState createState() => _NominateAwqafSheetState();
}

class _NominateAwqafSheetState extends State<NominateAwqafSheet> {
  // مصفوفة لمتابعة حالة التحديد لكل جزء
  List<bool> _selected = List.filled(30, false);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AwqafController>();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40, height: 5, margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Text('اختر أجزاء القرآن للترشيح', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text('الجزء ${index + 1}'),
                    value: _selected[index],
                    onChanged: (val) {
                      setState(() {
                        _selected[index] = val ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // جمع الأجزاء المحددة وإرسال الطلب
                final selectedParts = [
                  for (int i = 0; i < 30; i++)
                    if (_selected[i]) i + 1
                ];
                await controller.nominateStudent(widget.studentToken, selectedParts);
                Navigator.pop(context);
              },
              child: Text("تأكيد الترشيح"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
