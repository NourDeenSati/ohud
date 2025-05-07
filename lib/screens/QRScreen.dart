import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ohud/controllers/AddNoteController.dart';
import 'package:ohud/controllers/AttendanceController.dart';
import 'package:ohud/screens/AttendanceScreen.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // الكاميرا
          MobileScanner(
            controller: MobileScannerController(),
            onDetect: (capture) {

                try{
                    final barcode = capture.barcodes.first;
              final value = barcode.rawValue;
                  if (value != null&&value.isNum ) {
                    Get.find<AttendanceController>().updateStudentId(value);
                    Navigator.pop(context);
                }
              }catch(e){print(e);}

            },
          ),

          // شريط علوي
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 8),
                const Text(
                  "امسح رمز الطالب",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // إرشادات
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Column(
              children: const [
                Text(
                  "وجّه الكاميرا نحو رمز QR الخاص بالطالب",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // إطار توجيهي للمسح
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
