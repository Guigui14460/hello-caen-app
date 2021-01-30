import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';

// ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  final DateTime initialValue;
  DateTime beginDate, endDate;
  final Function onChanged;
  final String label, placeholder;

  DatePicker(
      {@required this.initialValue,
      @required this.onChanged,
      @required this.label,
      @required this.placeholder,
      this.beginDate,
      this.endDate}) {
    if (this.beginDate == null) {
      this.beginDate = DateTime(1900);
    }
    if (this.endDate == null) {
      this.endDate = DateTime(2100);
    }
  }
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialValue;
    _textEditingController.text = convertDatetimeToString(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: AlwaysDisabledFocusNode(),
      controller: _textEditingController,
      decoration: InputDecoration(
          labelText: widget.label, hintText: widget.placeholder),
      onTap: () async {
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: widget.beginDate,
        lastDate: widget.endDate,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                onPrimary: Colors.white,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _textEditingController
        ..text = convertDatetimeToString(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
      widget.onChanged(newSelectedDate);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
