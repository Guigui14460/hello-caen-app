import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../components/app_bar.dart';
import '../../components/checkbox_form_field.dart';
import '../../components/custom_dialog.dart';
import '../../components/date_picker.dart';
import '../../components/default_button.dart';
import '../../components/form_error.dart';
import '../../helper/keyboard.dart';
import '../../model/commerce.dart';
import '../../model/reduction_code.dart';
import '../../model/database/commerce_model.dart';
import '../../model/database/reduction_code_model.dart';
import '../../services/size_config.dart';

class UpdateReductionCodeScreen extends StatefulWidget {
  static String routeName = "/pro/reduction-codes/update";

  UpdateReductionCodeScreen(
      {@required this.commerce,
      this.code,
      this.modify = true,
      this.addCallback,
      this.modifyCallback}) {
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
  double _reductionAmount;

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
    } else {
      setState(() {
        _conditions = "";
        _beginDate = DateTime.now();
        _endDate = DateTime.now().add(Duration(days: 30));
        _maxAvailableCode = 0;
        _usePercentage = false;
        _reductionAmount = 0.0;
      });
    }
    ReductionCodeModel()
        .where("commerce",
            isEqualTo: CommerceModel().getDocumentReference(widget.commerce.id))
        .then((value) {
      setState(() {
        _otherCommerceCode = value;
      });
    });
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
          actions: [Icon(Icons.info_outline)],
          actionsCallback: [() => _infoDialog(context)],
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
                        buildConditionsFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildUsePercentageFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildMaxAvailableCodeFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildReductionAmountFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        DatePicker(
                          beginDate: DateTime.now(),
                          label: "Date de commencement",
                          placeholder:
                              "Sélectionnez la date où la réduction sera valide",
                          initialValue: _beginDate,
                          onChanged: (value) {
                            setState(() {
                              _beginDate = value;
                            });
                          },
                        ),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        DatePicker(
                          beginDate: DateTime.now(),
                          label: "Date de fin (jour inclue dans la validité)",
                          placeholder:
                              "Sélectionnez la date où la réduction cessera d'être valide",
                          initialValue: _endDate,
                          onChanged: (value) {
                            setState(() {
                              _endDate = value;
                            });
                          },
                        ),
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

  Widget buildConditionsFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      initialValue: _conditions,
      maxLines: 7,
      maxLength: 500,
      onSaved: (newValue) => _conditions = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCodeConditionNullError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCodeConditionNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Conditions",
          hintText: "Entrez vos conditions pour bénéficier de votre réduction"),
    );
  }

  Widget buildUsePercentageFormField() {
    return CheckboxFormField(
      title: Text("Utiliser un pourcentage"),
      initialValue: _usePercentage,
      onSaved: (newValue) => _usePercentage = newValue,
      validator: (value) => null,
    );
  }

  Widget buildMaxAvailableCodeFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: "$_maxAvailableCode",
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      onSaved: (newValue) => _maxAvailableCode = int.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCodeMaxAvailableNullError);
        }
        if (int.tryParse(value) != null) {
          removeError(error: kCodeMaxAvailableInvalidError);
          if (int.tryParse(value) >= 0) {
            removeError(error: kCodeMaxAvailableNegativError);
          }
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCodeMaxAvailableNullError);
        }
        if (int.tryParse(value) == null) {
          addError(error: kCodeMaxAvailableInvalidError);
        } else if (int.tryParse(value) < 0) {
          addError(error: kCodeMaxAvailableNegativError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Nombre de codes disponibles",
          hintText: "Entrez le nombre de codes disponibles"),
    );
  }

  Widget buildReductionAmountFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: "$_reductionAmount",
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      onSaved: (newValue) => _reductionAmount = double.parse(newValue),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCodeReductionAmountNullError);
        }
        if (double.tryParse(value) != null) {
          removeError(error: kCodeReductionAmountInvalidError);
          if (double.tryParse(value) >= 0) {
            removeError(error: kCodeReductionAmountNegativError);
          }
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCodeReductionAmountNullError);
        }
        if (double.tryParse(value) == null) {
          addError(error: kCodeReductionAmountInvalidError);
        } else if (double.tryParse(value) < 0) {
          addError(error: kCodeReductionAmountNegativError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Montant", hintText: "Entrez le montant de la réduction"),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: _name,
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCodeNameNullError);
        }
        bool ok = true;
        for (ReductionCode code in _otherCommerceCode) {
          if (code.name == value) {
            if (widget.modify && widget.code.id != code.id) {
              ok = false;
            } else if (!widget.modify) {
              ok = false;
            }
            if (!ok) {
              break;
            }
          }
        }
        if (ok) {
          removeError(error: kCodeNameAlreadyInUseError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kCodeNameNullError);
        }
        for (ReductionCode code in _otherCommerceCode) {
          if (code.name == value) {
            if (widget.modify && widget.code.id != code.id) {
              addError(error: kCodeNameAlreadyInUseError);
            } else if (!widget.modify) {
              addError(error: kCodeNameAlreadyInUseError);
            }
            break;
          }
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Nom", hintText: "Entrez le nom de votre code"),
    );
  }

  void _update(BuildContext context) async {
    if (_formKey.currentState.validate() && errors.isEmpty) {
      _formKey.currentState.save();
      KeyboardUtil.hideKeyboard(context);
      try {
        ReductionCode code = ReductionCode(
          id: widget.code.id,
          name: _name,
          conditions: _conditions,
          beginDate: _beginDate,
          endDate: _endDate,
          maxAvailableCodes: _maxAvailableCode,
          usePercentage: _usePercentage,
          reductionAmount: _reductionAmount,
          notifyAllUser: widget.code.notifyAllUser,
          commerceId: widget.commerce.id,
        );
        await ReductionCodeModel().update(code.id, code).then((value) {
          widget.modifyCallback(code);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Données mises à jour")));
          Navigator.pop(context);
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur lors de la mise à jour des données")));
      }
    }
  }

  void _create(BuildContext context) async {
    if (_formKey.currentState.validate() && errors.isEmpty) {
      _formKey.currentState.save();
      KeyboardUtil.hideKeyboard(context);
      try {
        ReductionCode code = ReductionCode(
          name: _name,
          conditions: _conditions,
          beginDate: _beginDate,
          endDate: _endDate,
          maxAvailableCodes: _maxAvailableCode,
          usePercentage: _usePercentage,
          reductionAmount: _reductionAmount,
          notifyAllUser: false,
          commerceId: widget.commerce.id,
        );
        ReductionCodeModel().create(code).catchError((error) {
          print(error);
        });
        await ReductionCodeModel()
            .whereLinked("commerce",
                isEqualTo:
                    CommerceModel().getDocumentReference(widget.commerce.id))
            .whereLinked("name", isEqualTo: _name)
            .executeCurrentLinkedQueryRequest()
            .then((value) {
          widget.addCallback(value[0]);
        });
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

  _infoDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Information",
            description:
                "Seul vous et les administrateurs pouvent modifier ces informations.",
            text: "OK",
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
  }
}
