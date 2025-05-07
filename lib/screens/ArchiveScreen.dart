import 'package:flutter/material.dart';
import 'package:ohud/components/MyArchiveContainer.dart';

class Archivescreen extends StatelessWidget {
  const Archivescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Myarchivecontainer(
            type: 'تسجيل صفحة',
            student: "خالد حمودة",
            detailes: "588/ممتاز ",
          ),
          Myarchivecontainer(
            type: 'تسجيل حضور',
            student: "سميح حمودة",
            detailes: "تأخر 5-12-2025 ",
          ),
          Myarchivecontainer(
            type: 'تسجيل ملاحظة',
            student: "خالد سميح",
            detailes: "شغب في الصف /سلبية ",
          ),
        ],
      ),
    );
  }
}
