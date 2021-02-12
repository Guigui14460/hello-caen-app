import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../reduction_code_detail/reduction_code_detail_screen.dart';
import '../../../constants.dart';
import '../../../model/reduction_code.dart';
import '../../../services/size_config.dart';

class SponsoredReductionCodeBanner extends StatelessWidget {
  final ReductionCode code;
  SponsoredReductionCodeBanner({Key key, @required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (code == null) {
      return Text("Aucune réduction sponsorisée disponible pour le moment");
    }
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ReductionCodeDetailScreen(code: code))),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(20),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              secondaryColor,
              secondaryColor.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text.rich(
          TextSpan(
            text: "Bon plan sponsorisé\n",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            children: [
              TextSpan(
                text: code.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
