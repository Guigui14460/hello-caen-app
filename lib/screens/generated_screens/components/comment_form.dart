import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../services/size_config.dart';

// ignore: must_be_immutable
class CommentForm extends StatefulWidget {
  String initialValue;
  double initialRating;
  bool error;

  CommentForm({Key key, this.initialValue = "", this.initialRating = 0}) {
    error = initialValue.isEmpty;
  }

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  bool _error;

  @override
  Widget build(BuildContext context) {
    if (this.mounted) {
      setState(() {
        _error = widget.error;
      });
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: widget.initialRating,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) => widget.initialRating = rating,
            ),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(12),
              vertical: getProportionateScreenHeight(12),
            ),
          ),
          keyboardType: TextInputType.text,
          maxLines: 7,
          initialValue: widget.initialValue,
          onChanged: (value) {
            if (this.mounted) {
              widget.error = value.isEmpty;
              setState(() {
                _error = widget.error;
              });
            }
            widget.initialValue = value;
          },
        ),
        (_error
            ? Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    "Le commentaire doit posséder un contenu",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              )
            : Container()),
      ],
    );
  }
}
