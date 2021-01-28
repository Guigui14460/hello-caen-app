import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_caen/model/database/reduction_code_model.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../components/app_bar.dart';
import '../../components/default_button.dart';
import '../../components/form_error.dart';
import '../../helper/keyboard.dart';
import '../../model/commerce.dart';
import '../../model/commerce_type.dart';
import '../../model/reduction_code.dart';
import '../../model/database/commerce_model.dart';
import '../../services/size_config.dart';
import '../../services/user_manager.dart';

class UpdateReductionCodeScreen extends StatefulWidget {
  static String routeName = "/pro/reduction-codes/update";

  UpdateReductionCodeScreen(this.commerce,
      {this.code, this.modify = true, this.addCallback, this.modifyCallback}) {
    assert(this.commerce != null);
    assert((modify &&
            code != null &&
            addCallback == null &&
            modifyCallback != null) ||
        (!modify &&
            code == null &&
            addCallback != null &&
            modifyCallback == null));
  }

  final ReductionCode code;
  final bool modify;
  final Commerce commerce;
  final void Function(ReductionCode) addCallback;
  final void Function(ReductionCode) modifyCallback;

  @override
  _UpdateReductionCodeScreenState createState() =>
      _UpdateReductionCodeScreenState();
}

class _UpdateReductionCodeScreenState extends State<UpdateReductionCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _conditions;
  DateTime _beginDate;
  DateTime _endDate;
  int _maxAvailableCode;
  bool _usePercentage;
  int _reductionAmount;

  List<ReductionCode> _otherCommerceCode = [];

  final List<String> errors = [];

  @override
  void initState() {
    super.initState();
    if (widget.modify) {
      setState(() {
        _name = widget.code.name;
        _conditions = widget.code.conditions;
        _beginDate = widget.code.beginDate;
        _endDate = widget.code.endDate;
        _maxAvailableCode = widget.code.maxAvailableCodes;
        _usePercentage = widget.code.usePercentage;
        _reductionAmount = widget.code.reductionAmount;
      });
    }
    ReductionCodeModel().where("commerce", isEqualTo: widget.commerce.id).then((value) {
      setState(() {
        _otherCommerceCode = value;
      });
    })
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(10)),
              child: Column(
                children: [
                  Text(
                    widget.modify
                        ? "Mise à jour du code de réduction \"${widget.code.name}\""
                        : "Ajouter un nouveau code de réduction",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(30)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildNameFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildCommerceTypeDropdownButton(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildDescriptionFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildLocationSelection(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildTimetablesFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        DefaultButton(
                            height: getProportionateScreenHeight(50),
                            text: widget.modify ? "Mettre à jour" : "Ajouter",
                            press: widget.modify
                                ? () => _update(context)
                                : () => _create(context),
                            longPress: () {}),
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDescriptionFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      initialValue: _description,
      maxLines: 15,
      maxLength: 2000,
      onSaved: (newValue) => _description = newValue,
      onChanged: (value) {},
      validator: (value) {
        return null;
      },
      decoration: InputDecoration(
          labelText: "Description", hintText: "Entrez une description"),
    );
  }

  Widget buildTimetablesFormField() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.multiline,
          initialValue: _timetables,
          maxLines: 7,
          maxLength: 200,
          onSaved: (newValue) => _timetables = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kCommerceTimetablesNullError);
            }
          },
          validator: (value) {
            if (value.isEmpty) {
              addError(error: kCommerceTimetablesNullError);
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: "Horaires", hintText: "Entrez des horaires"),
        ),
        SizedBox(height: getProportionateScreenHeight(3)),
        Text(
          "N.B.: Nous vous conseillons d'écrire les horaires sous la forme à chaque ligne : \"JOUR HH:MM - HH:MM\".",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget buildLocationSelection() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          initialValue: "${_latitude == null ? 0 : _latitude}",
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.-]')),
          ],
          onSaved: (newValue) => _latitude = double.parse(newValue),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kCommerceLatitudeNullError);
            }
          },
          validator: (value) {
            if (value.isEmpty) {
              addError(error: kCommerceLatitudeNullError);
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: "Latitude",
              hintText: "Entrez la latitude de votre commerce"),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        TextFormField(
          keyboardType: TextInputType.number,
          initialValue: "${_longitude == null ? 0 : _longitude}",
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.-]')),
          ],
          onSaved: (newValue) => _longitude = double.parse(newValue),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kCommerceLongitudeNullError);
            }
          },
          validator: (value) {
            if (value.isEmpty) {
              addError(error: kCommerceLongitudeNullError);
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: "Longitude",
              hintText: "Entrez la longitude de votre commerce"),
        ),
      ],
    );
  }

  Widget buildCommerceTypeDropdownButton() {
    return new DropdownButtonFormField<CommerceType>(
      isExpanded: true,
      value: _type,
      hint: _type != null ? Text(_type.name) : Text("Sélectionnez un type"),
      items: _typesAvailable.map((CommerceType value) {
        return new DropdownMenuItem(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (value) {
        removeError(error: kCommerceTypeNullError);
      },
      onSaved: (newValue) => _type = newValue,
      validator: (value) {
        if (value == null) {
          addError(error: kCommerceTypeNullError);
        }
        return null;
      },
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: _name,
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCommerceNameNullError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCommerceNameNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Nom", hintText: "Entrez le nom de votre commerce"),
    );
  }

  void _update(BuildContext context) async {
    if (_formKey.currentState.validate() && errors.isEmpty) {
      _formKey.currentState.save();
      KeyboardUtil.hideKeyboard(context);
      try {
          futureCommerce = Commerce(
            id: widget.commerce.id,
            ownerId: widget.commerce.ownerId,
            name: _name,
            description: _description,
            location: "$_latitude,$_longitude",
            timetables: _timetables,
            typeId: _type.id,
            commentIds: widget.commerce.commentIds,
            dateAdded: widget.commerce.dateAdded,
            dateModified: DateTime.now(),
            imageLink: widget.commerce.imageLink,
          );
          await CommerceModel()
              .update(widget.commerce.id, futureCommerce)
              .catchError((error) {
            print(error);
          });
        }
        widget.modifyCallback(futureCommerce);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Données mises à jour")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur lors de la mise à jour des données")));
    }
  }

  void _create(BuildContext context) async {
    UserManager userManager = Provider.of<UserManager>(context, listen: false);
    if (_formKey.currentState.validate() && errors.isEmpty) {
      _formKey.currentState.save();
      KeyboardUtil.hideKeyboard(context);
      try {
              futureCommerce = Commerce(
                id: id,
                ownerId: userManager.getLoggedInUser().id,
                name: _name,
                description: _description,
                location: "$_latitude,$_longitude",
                timetables: _timetables,
                typeId: _type.id,
                commentIds: [],
                dateAdded: DateTime.now(),
                imageLink: link,
              );
              CommerceModel()
                  .createWithId(id, futureCommerce)
                  .catchError((error) {
                print(error);
              });
              widget.addCallback(futureCommerce);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Code de réduction ajouté")));
        Navigator.pop(context);
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de la création")));
      }
    }
  }
}
