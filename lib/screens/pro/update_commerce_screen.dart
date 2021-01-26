import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_caen/model/database/commerce_type_model.dart';
import 'package:provider/provider.dart';

import 'preview_page.dart';
import '../../components/app_bar.dart';
import '../../components/default_button.dart';
import '../../model/commerce.dart';
import '../../model/commerce_type.dart';
import '../../model/user_account.dart';
import '../../services/size_config.dart';
import '../../services/user_manager.dart';

class UpdateCommerceScreen extends StatefulWidget {
  static String routeName = "/pro/commerce/update";

  UpdateCommerceScreen({this.commerce, this.modify = true}) {
    assert((modify && commerce != null) || (!modify && commerce == null));
  }

  final Commerce commerce;
  final bool modify;

  @override
  _UpdateCommerceScreenState createState() => _UpdateCommerceScreenState();
}

class _UpdateCommerceScreenState extends State<UpdateCommerceScreen> {
  Commerce futureCommerce;
  List<CommerceType> _typesAvailable = [];

  final _formKey = GlobalKey<FormState>();
  String _name;
  String _location;
  String _timetables;
  CommerceType _type;
  String _imageLink;

  final List<String> errors = [];
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    if (widget.modify) {
      setState(() {
        _name = widget.commerce.name;
        _location = widget.commerce.location;
        _timetables = widget.commerce.timetables;
        _imageLink = widget.commerce.imageLink;
      });
    }
    CommerceTypeModel().getAll().then((value) {
      setState(() {
        _typesAvailable = value;
        if (widget.modify) {
          _type = _typesAvailable
              .firstWhere((element) => element.id == widget.commerce.typeId);
        }
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
    UserManager userManager = Provider.of<UserManager>(context);
    User user = userManager.getLoggedInUser();

    DefaultButton button = DefaultButton(
        height: getProportionateScreenHeight(50),
        text: widget.modify ? "Mettre à jour" : "Ajouter",
        press: widget.modify ? _update : _create,
        longPress: () {});

    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          actions: [Icon(Icons.visibility)],
          actionsCallback: [
            () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        PreviewCommerceScreen(commerce: futureCommerce)))
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    widget.modify
                        ? "Mise à jour du commerce \"${widget.commerce.name}\""
                        : "Ajouter un nouveau commerce",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getProportionateScreenWidth(30)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Form(
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildNameFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildCommerceTypeDropdownButton(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        (_isValidated
                            ? button
                            : Visibility(
                                child: button,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: false,
                              )),
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
        setState(() {
          _type = value;
        });
      },
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      initialValue: _name,
      onSaved: (newValue) => _name = newValue,
      onChanged: (value) {},
      validator: (value) {
        return null;
      },
      decoration: InputDecoration(
          labelText: "Nom", hintText: "Entrez le nom de votre commerce"),
    );
  }

  void _update() async {}

  void _create() async {}
}
