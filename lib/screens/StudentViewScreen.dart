import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyStudentInfo.dart';
import 'package:ohud/components/MyStudentInfo2.dart';
import 'package:ohud/controllers/studentviewController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class StudentViewScreen extends StatelessWidget {
  final int studentId;
  final StudentController controller = Get.put(StudentController());

  StudentViewScreen({super.key, required this.studentId}) {
    controller.fetchStudentData(studentId);
  }
  String _cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: ''),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
          );
        }

        final data = controller.studentData;
        return RefreshIndicator(
          color: Colors.teal,
          onRefresh: () async {
            await controller.fetchStudentData(studentId);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Symbols.person_filled_rounded,
                      color: Color(0XFF000000),
                      size: 100,
                    ),
                    Text(
                      data['name'] ?? 'اسم غير معروف',
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final phone = data['student_phone'] ?? '';
                        Clipboard.setData(ClipboardData(text: phone));
                        Get.snackbar(
                          "تم النسخ",
                          "تم نسخ رقم الطالب إلى الحافظة",
                          colorText: Colors.black,
                          snackPosition: SnackPosition.TOP,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Mystudentinfo(
                        type: 'رقم الهاتف',
                        info: data['student_phone'] ?? '',
                      ),
                    ),
                    Mystudentinfo(type: 'المستوى', info: data['level']),
                    Mystudentinfo(
                      type: 'النقاط',
                      info: data['points'].toString(),
                    ),
                    Mystudentinfo(
                      type: 'الترتيب على الحلقة',
                      info: data['rank_in_circle'].toString(),
                    ),
                    Mystudentinfo(
                      type: 'الترتيب على المسجد',
                      info: data['rank_in_mosque'].toString(),
                    ),

                    Mystudentinfo(
                      type: 'الملاحظات الإيجابية',
                      info: data['positive_notes'].toString(),
                    ),
                    Mystudentinfo(
                      type: 'الملاحظات السلبية',
                      info: data['negative_notes'].toString(),
                    ),
                    Mystudentinfo(
                      type: 'الصفحات المسمعة ',
                      info: data['recitations_count'].toString(),
                    ),
                    Mystudentinfo(
                      type: 'الأجزاء المسبورة ',
                      info: data['sabrs_count'].toString(),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder:
                              (_) => RecitationArchiveSheet(
                                recitations: data['recitation_history'],
                              ),
                        );
                      },
                      icon: Icon(Icons.menu_book_rounded, color: Colors.white),
                      label: Text("عرض أرشيف التسميع"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class RecitationArchiveSheet extends StatefulWidget {
  final List recitations;

  const RecitationArchiveSheet({super.key, required this.recitations});

  @override
  State<RecitationArchiveSheet> createState() => _RecitationArchiveSheetState();
}

class _RecitationArchiveSheetState extends State<RecitationArchiveSheet> {
  bool showOnlyRecited = false;
  bool sortDescending = false;

  Map<int, List<Map>> groupPagesByParts(List<Map> recitations) {
    Map<int, List<Map>> parts = {};
    for (var r in recitations) {
      int page = r['page'] ?? 0;

      int part = 1;
      if (page <= 21) {
        part = 1;
      } else if (page >= 582) {
        part = 30;
      } else {
        part = ((page - 22) / 20).floor() + 2;
      }

      if (!parts.containsKey(part)) {
        parts[part] = [];
      }
      parts[part]!.add(r);
    }
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map> recitations = widget.recitations.cast<Map>();
    final filtered =
        showOnlyRecited
            ? recitations.where((r) => r['recited'] == true).toList()
            : recitations;

    final grouped = groupPagesByParts(filtered);

    // نحصل على المفاتيح ونرتبها حسب الخيار المحدد
    final sortedEntries =
        grouped.entries.toList()..sort(
          (a, b) =>
              sortDescending ? b.key.compareTo(a.key) : a.key.compareTo(b.key),
        );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      builder:
          (_, controller) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: controller,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أرشيف التسميع',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            sortDescending
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.teal,
                          ),
                          tooltip: 'عكس الترتيب',
                          onPressed: () {
                            setState(() {
                              sortDescending = !sortDescending;
                            });
                          },
                        ),
                        Text('المسمعة فقط', style: TextStyle(fontSize: 14)),
                        Switch(
                          activeColor: Colors.teal,
                          value: showOnlyRecited,
                          onChanged: (val) {
                            setState(() {
                              showOnlyRecited = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (var part in sortedEntries)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الجزء ${part.key}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...part.value.map((r) {
                        final page = r['page'];
                        final recited = r['recited'];
                        final result = r['result'];

                        String status = '';
                        if (recited == true) status = 'قديم';
                        if (result != null) status = result.toString();

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.teal.shade100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('الصفحة $page'),
                              Text(
                                status,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 12),
                    ],
                  ),
              ],
            ),
          ),
    );
  }
}
