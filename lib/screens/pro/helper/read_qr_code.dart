import 'package:barcode_scan_fix/barcode_scan.dart';

import '../../../model/reduction_code_used.dart';
import '../../../model/database/reduction_code_model.dart';
import '../../../model/database/reduction_code_used_model.dart';
import '../../../model/database/user_model.dart';

enum QRCodeResult {
  OK,
  ALREADY_USED,
  NO_SCAN,
  ERROR,
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
  ReductionCodeUsedModel model = ReductionCodeUsedModel();
  try {
    return await model
        .whereLinked("reductionCode",
            isEqualTo:
                ReductionCodeModel().getDocumentReference(splitedString[0]))
        .whereLinked("user",
            isEqualTo: UserModel().getDocumentReference(splitedString[1]))
        .executeCurrentLinkedQueryRequest()
        .then((value) async {
      if (value.length > 0) {
        return QRCodeResult.ALREADY_USED;
      }
      return await model
          .create(ReductionCodeUsed(
              userId: splitedString[1],
              reductionCodeId: splitedString[0],
              whenUsed: DateTime.now()))
          .then((id) {
        if (id != null) {
          return QRCodeResult.OK;
        } else {
          return QRCodeResult.ERROR;
        }
      });
    });
  } catch (e) {
    return QRCodeResult.ERROR;
  }
}
