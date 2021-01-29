import 'package:barcode_scan_fix/barcode_scan.dart';

import '../../model/database/reduction_code_model.dart';

enum QRCodeResult {
  OK,
  ALREADY_USED,
  NO_SCAN,
}

Future<String> readQrCode() async {
  String result = await BarcodeScanner.scan().catchError((error) {
    return null;
  });
  return result;
}

Future<QRCodeResult> readQrCodeAndApplyReductionCode() async {
  String result = await readQrCode();
  if (result == null) {
    return QRCodeResult.NO_SCAN;
  }
  List<String> splitedString = result.split(",");
  ReductionCodeModel model = ReductionCodeModel();
  return await model.getById(splitedString[0]).then((code) {
    if (code.userIdsWhoUsedCode.contains(splitedString[1])) {
      return QRCodeResult.ALREADY_USED;
    }
    code.userIdsWhoUsedCode.add(splitedString[1]);
    model.update(code.id, code);
    return QRCodeResult.OK;
  });
}
