import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ohud/components/MyAppBar.dart';
import 'package:ohud/components/MyStudentInfo.dart';
import 'package:ohud/components/MyStudentInfo2.dart';
import 'package:ohud/components/NominateAwqafSheet.dart';
import 'package:ohud/controllers/AbsenceController.dart';
import 'package:ohud/controllers/AwqafController.dart' show AwqafController;
import 'package:ohud/controllers/studentviewController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class StudentViewScreen extends StatelessWidget {
  final int studentId;
  final int studentToken;
  final StudentController controller = Get.put(StudentController());

  StudentViewScreen({
    super.key,
    required this.studentId,
    required this.studentToken,
  }) {
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildVerticalButton(
                            icon: Icons.menu_book_rounded,
                            label: "أرشيف التسميع",
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
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
                          ),
                          _buildVerticalButton(
                            icon: Icons.mosque,
                            label: "ترشيح للأوقاف",
                            onPressed: () {
                              final awqafController = Get.put(
                                AwqafController(),
                              );
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder:
                                    (_) => NominateAwqafSheet(
                                      studentToken: studentToken,
                                    ),
                              );
                            },
                          ),
                          _buildVerticalButton(
                            icon: Icons.event_available,
                            label: "أرشيف الحضور",
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder:
                                    (_) => AttendenceArchiveSheet(
                                      attendances: data['attendances'],
                                      studentToken: studentToken,
                                    ),
                              );
                            },
                          ),
                        ],
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

Widget _buildVerticalButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: Colors.white),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
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

class AttendenceArchiveSheet extends StatefulWidget {
  final List attendances;
  final int studentToken;
  const AttendenceArchiveSheet({
    super.key,
    required this.attendances,
    required this.studentToken,
  });

  @override
  State<AttendenceArchiveSheet> createState() => _AttendenceArchiveSheet();
}

class _AttendenceArchiveSheet extends State<AttendenceArchiveSheet> {
  bool sortDescending = false;

  final AbsenceController absenceCtrl = Get.put(AbsenceController());

  void _showJustificationDialog(DateTime date) {
    final TextEditingController reasonCtrl = TextEditingController();
    absenceCtrl.updateStudentId(widget.studentToken.toString());
    absenceCtrl.updateAbsenceDate(date);

    Get.defaultDialog(
      title: "تبرير الغياب",
      content: Column(
        children: [
          Text(
            "يرجى كتابة سبب تبرير الغياب ليوم ${DateFormat('yyyy-MM-dd').format(date)}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reasonCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "اكتب سبب التبرير هنا",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => absenceCtrl.reason.value = val,
          ),
        ],
      ),
      textConfirm: "إرسال",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (reasonCtrl.text.trim().isEmpty) {
          Get.snackbar(
            "تنبيه",
            "يرجى إدخال سبب التبرير",
            colorText: Colors.black,
          );
          return;
        }

        final success = await absenceCtrl.submitAttendance();
        if (success) {
          // إغلاق الـ BottomSheet الذي فُتح عبر showModalBottomSheet
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map> attendanceList = widget.attendances.cast<Map>();

    attendanceList.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return sortDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });

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
                      'أرشيف الحضور',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                  ],
                ),
                const SizedBox(height: 12),
                ...attendanceList.map((entry) {
                  final date = DateTime.parse(entry['date']);
                  final attendanceType = entry['attendanceType'] ?? '';
                  final formattedDate = DateFormat('yyyy-MM-dd').format(date);

                  final isUnexcused = attendanceType == "غياب غير مبرر";

                  return GestureDetector(
                    onTap: () {
                      if (isUnexcused) {
                        _showJustificationDialog(date);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUnexcused ? Colors.red.shade50 : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isUnexcused
                                  ? Colors.red.shade200
                                  : Colors.teal.shade100,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('تاريخ $formattedDate'),
                          Text(
                            attendanceType,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isUnexcused ? Colors.red : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
    );
  }
}
