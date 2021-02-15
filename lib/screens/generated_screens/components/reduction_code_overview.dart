import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../reduction_code_detail/reduction_code_detail_screen.dart';
import '../../../model/reduction_code.dart';
import '../../../services/size_config.dart';

class ReductionCodeOverviewWidget extends StatelessWidget {
  final ReductionCode code;
  const ReductionCodeOverviewWidget({Key key, @required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        border: Border(),
      ),
      padding: EdgeInsets.only(
        right: getProportionateScreenHeight(8),
      ),
      child: OutlineButton(
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ReductionCodeDetailScreen(code: code),
          ),
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(24)),
        child: Text(code.name),
      ),
    );
  }
}
