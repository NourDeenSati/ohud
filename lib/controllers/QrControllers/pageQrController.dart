import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ohud/controllers/AddNoteController.dart';
import 'package:ohud/controllers/AddPageController.dart';
import 'package:ohud/controllers/AttendanceController.dart';

class PageQRScannerController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();

  /// متغير تحكم بالفحص لمنع التكرار
  bool isScanning = false;

  void onDetect(BarcodeCapture capture) {
    if (isScanning) {
      return; // في فحص جارٍ بالفعل، تجاهل هذا الاستدعاء
    }

    isScanning = true;

    try {
      final barcode = capture.barcodes.first;
      final value = barcode.rawValue;

      if (value != null && value.isNum) {
        Get.find<PageRegisterController>().updateStudentId(value);
        Get.back();
      }
    } catch (e) {
      print("QR Error: $e");
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
