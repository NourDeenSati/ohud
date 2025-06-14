import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ohud/controllers/QrControllers/AttenQRController.dart';
import 'package:ohud/controllers/QrControllers/noteQRController.dart';
import 'package:ohud/controllers/QrControllers/pageQrController.dart';

class PageQRViewExample extends GetView<PageQRScannerController> {
  const PageQRViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.scannerController,
            onDetect: controller.onDetect,
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
          const Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Text(
              "وجّه الكاميرا نحو رمز QR الخاص بالطالب",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),

          // إطار توجيهي
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
