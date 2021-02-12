import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'preview_commerce.dart';
import '../components/map_object.dart';
import '../../../constants.dart';
import '../../../components/app_bar.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../components/modal_box.dart';
import '../../../helper/zoombuttons_plugin.dart';
import '../../../helper/keyboard.dart';
import '../../../model/commerce.dart';
import '../../../model/commerce_type.dart';
import '../../../model/database/commerce_model.dart';
import '../../../model/database/commerce_type_model.dart';
import '../../../services/firebase_settings.dart';
import '../../../services/size_config.dart';
import '../../../services/user_manager.dart';

class UpdateCommerceScreen extends StatefulWidget {
  static String routeName = "/pro/commerce/update";

  UpdateCommerceScreen(
      {this.commerce,
      this.modify = true,
      this.addCallback,
      this.modifyCallback}) {
    assert((modify &&
            commerce != null &&
            addCallback == null &&
            modifyCallback != null) ||
        (!modify &&
            commerce == null &&
            addCallback != null &&
            modifyCallback == null));
  }

  final Commerce commerce;
  final bool modify;
  final void Function(Commerce) addCallback;
  final void Function(Commerce) modifyCallback;

  @override
  _UpdateCommerceScreenState createState() => _UpdateCommerceScreenState();
}

class _UpdateCommerceScreenState extends State<UpdateCommerceScreen> {
  Commerce futureCommerce;
  List<CommerceType> _typesAvailable = [];

  final _formKey = GlobalKey<FormState>();
  MapController _mapController = MapController();

  String _name;
  String _description;
  LatLng _location;
  LatLng _selectedLocation;
  String _timetables;
  CommerceType _type;
  String _imageLink;
  PickedFile _image;

  final List<String> errors = [];

  void _handleTap(LatLng latlng) {
    setState(() {
      _location = latlng;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.modify) {
      LatLng loc = LatLng(widget.commerce.latitude, widget.commerce.longitude);
      setState(() {
        _name = widget.commerce.name;
        _location = loc;
        _selectedLocation = loc;
        _timetables = widget.commerce.timetables;
        _description = widget.commerce.description;
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
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          actions: [Icon(Icons.visibility)],
          actionsCallback: [
            () {
              return Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PreviewCommerceScreen(
                            name: _name,
                            description: _description,
                            latitude: _selectedLocation.latitude,
                            longitude: _selectedLocation.longitude,
                            image: _image,
                            imageLink: _imageLink,
                            type: _type,
                            timetables: _timetables,
                          )));
            }
          ],
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
                        ? "Mise à jour du commerce \"${widget.commerce.name}\""
                        : "Ajouter un nouveau commerce",
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
                        buildImageLinkPreview(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildTimetablesFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        buildMapLocationField(context),
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

  void _openMap(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalBox(
          title: "Choisir la localisation du lieu",
          textButton: "Confirmer la localisation",
          widget: MapObject(
            height: 300,
            initialZoom: 11.5,
            maxZoom: 19,
            initialLocation: _location,
            onTap: _handleTap,
            slideOnBoundaries: true,
          ),
          onPressed: () {
            setState(() {
              _selectedLocation = _location;
            });
            Navigator.pop(context);
            _mapController.move(_selectedLocation, _mapController.zoom);
          },
        );
      },
    );
  }

  Widget buildMapLocationField(BuildContext context) {
    return Column(
      children: [
        Container(
          height: getProportionateScreenHeight(300),
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center:
                  _selectedLocation == null ? caenLocation : _selectedLocation,
              zoom: 15,
              minZoom: 11.5,
              boundsOptions: FitBoundsOptions(padding: EdgeInsets.zero),
              plugins: [
                ZoomButtonsPlugin(),
              ],
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 30,
                    height: 30,
                    point: _selectedLocation,
                    anchorPos: AnchorPos.align(AnchorAlign.top),
                    builder: (ctx) =>
                        Icon(Icons.place, color: Colors.red, size: 30),
                  ),
                ],
              ),
            ],
            nonRotatedLayers: [
              ZoomButtonsPluginOption(
                minZoom: 4,
                maxZoom: 19,
              ),
            ],
          ),
        ),
        TextButton(
            onPressed: () => _openMap(context),
            child: Text("Ouvrir la carte", style: TextStyle(fontSize: 18))),
      ],
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

  Widget buildImageLinkPreview() {
    Widget getImage() {
      if (_imageLink != null) {
        return Image.network(
          _imageLink,
          width: double.infinity,
        );
      }
      if (_image != null) {
        return Image.file(
          File(_image.path),
          width: double.infinity,
        );
      }
      return Center(
        child: Text("Sélectionner une image"),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _changePicture,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                  width: 1, color: Colors.grey[400], style: BorderStyle.solid)),
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            child: getImage(),
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Future<void> _changePicture() async {
    PickedFile image =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
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
    if (_image != null || (_imageLink != null && _imageLink != "")) {
      removeError(error: kCommerceImageLinkNullError);
    } else {
      addError(error: kCommerceImageLinkNullError);
    }
    if (_selectedLocation != null) {
      removeError(error: kLocationNullError);
    } else {
      addError(error: kLocationNullError);
    }
    if (_formKey.currentState.validate() && errors.isEmpty) {
      _formKey.currentState.save();
      KeyboardUtil.hideKeyboard(context);
      try {
        if (_image != null) {
          FirebaseSettings.instance
              .uploadFile(_image, context, "enterprise-pictures",
                  "${widget.commerce.id}.jpg")
              .asStream()
              .listen((event) {
            if (event.snapshot.totalBytes - event.snapshot.bytesTransferred !=
                0) {
              event.then((task) async {
                String link = await task.ref.getDownloadURL();
                futureCommerce = Commerce(
                  id: widget.commerce.id,
                  ownerId: widget.commerce.ownerId,
                  name: _name,
                  description: _description,
                  latitude: _selectedLocation.latitude,
                  longitude: _selectedLocation.longitude,
                  timetables: _timetables,
                  typeId: _type.id,
                  imageLink: link,
                );
                CommerceModel()
                    .update(widget.commerce.id, futureCommerce)
                    .catchError((error) {
                  print(error);
                });
              });
            }
          });
        } else {
          futureCommerce = Commerce(
            id: widget.commerce.id,
            ownerId: widget.commerce.ownerId,
            name: _name,
            description: _description,
            latitude: _selectedLocation.latitude,
            longitude: _selectedLocation.longitude,
            timetables: _timetables,
            typeId: _type.id,
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
  }

  void _create(BuildContext context) async {
    UserManager userManager = Provider.of<UserManager>(context, listen: false);
    if (_image != null || (_imageLink != null && _imageLink != "")) {
      removeError(error: kCommerceImageLinkNullError);
    } else {
      addError(error: kCommerceImageLinkNullError);
    }
    if (_selectedLocation != null) {
      removeError(error: kLocationNullError);
    } else {
      addError(error: kLocationNullError);
    }
    if (_formKey.currentState.validate() && errors.isEmpty) {
      _formKey.currentState.save();
      KeyboardUtil.hideKeyboard(context);
      try {
        String id = Uuid().v4();
        FirebaseSettings.instance
            .uploadFile(_image, context, "enterprise-pictures", "$id.jpg")
            .asStream()
            .listen((event) {
          if (event.snapshot.totalBytes - event.snapshot.bytesTransferred !=
              0) {
            event.then((task) async {
              String link = await task.ref.getDownloadURL();
              futureCommerce = Commerce(
                id: id,
                ownerId: userManager.getLoggedInUser().id,
                name: _name,
                description: _description,
                latitude: _selectedLocation.latitude,
                longitude: _selectedLocation.longitude,
                timetables: _timetables,
                typeId: _type.id,
                imageLink: link,
              );
              CommerceModel()
                  .createWithId(id, futureCommerce)
                  .catchError((error) {
                print(error);
              });
              widget.addCallback(futureCommerce);
            });
          }
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Commerce ajouté")));
        Navigator.pop(context);
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de la création")));
      }
    }
  }
}
