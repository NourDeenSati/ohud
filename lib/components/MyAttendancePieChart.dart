import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttendancePieChart extends StatelessWidget {
  final RxMap<String, double> data;

  AttendancePieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // تحويل البيانات من RxMap إلى List<_ChartData>
      final chartData = data.entries.map((entry) {
        return _ChartData(
          entry.key,
          (entry.value * 100).toDouble(), // ← تحويل من نسبة عشرية إلى مئوية
          _getColorForLabel(entry.key),
        );
      }).toList();

      return SizedBox(
        height: 250,
        child: SfCircularChart(
          title: ChartTitle(text: 'نسب الحضور'),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          series: <PieSeries<_ChartData, String>>[
            PieSeries<_ChartData, String>(
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.label,
              yValueMapper: (_ChartData data, _) => data.value,
              pointColorMapper: (_ChartData data, _) => data.color,
              dataLabelMapper: (_ChartData data, _) =>
                  ' (${data.value.toStringAsFixed(1)}%)',
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve,
                  length: '10%',
                ),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    });
  }

  // تعيين لون لكل نوع حضور
  Color _getColorForLabel(String label) {
    switch (label) {
      case 'حضور':
        return Colors.green;
      case 'تأخير':
        return Colors.yellow[700]!;
      case 'غياب مبرر':
        return Colors.orange;
      case 'غياب غير مبرر':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _ChartData {
  final String label;
  final double value;
  final Color color;

  _ChartData(this.label, this.value, this.color);
}
