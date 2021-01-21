import 'package:flutter/material.dart';

import '../services/size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key key,
    @required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Column(
          children: List.generate(
              errors.length, (index) => formErrorText(error: errors[index]))),
    );
  }

  Widget formErrorText({String error}) {
    return Row(
      children: [
        Icon(
          Icons.error,
          size: getProportionateScreenHeight(20),
          color: Colors.redAccent,
        ),
        SizedBox(width: 5),
        Text(
          error,
          style: TextStyle(
            fontSize: getProportionateScreenHeight(16),
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
