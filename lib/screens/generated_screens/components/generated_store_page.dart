import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../components/app_bar.dart';
import '../../../components/comment_verifier.dart';
import '../../../components/new_comment_box.dart';
import '../../../model/comment.dart';
import '../../../model/commerce.dart';
import '../../../model/database/comment_model.dart';
import '../../../model/database/commerce_model.dart';
import '../../../services/size_config.dart';
import '../../../services/theme_manager.dart';

import 'package:hello_caen/components/app_bar.dart';
import 'package:hello_caen/model/commerce.dart';
import 'package:hello_caen/services/size_config.dart';



class GeneratedStorePage extends StatefulWidget {
  final Commerce data;

  const GeneratedStorePage({Key key, @required this.data}) : super(key: key);
  @override
  _GeneratedStorePageState createState() => _GeneratedStorePageState();
}

class _GeneratedStorePageState extends State<GeneratedStorePage> {
  Widget build(BuildContext context) {
    ThemeManager manager = Provider.of<ThemeManager>(context);

    List<Comment> comments = [];
    CommentModel()
        .where("commerce",
            isEqualTo: CommerceModel().getDocumentReference(widget.data.id))
        .then((value) {
      if (this.mounted) {
        setState(() {
          comments = value;
        });
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getProportionateScreenHeight(300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Stack(children: [
                  Hero(
                    tag: widget.data.id,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.data.imageLink),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  /*Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF343434).withOpacity(0.7),
                                Color(0xFF343434).withOpacity(0.55),
                              ]))),*/
                ]),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -75.0, 0.0),
                height: getProportionateScreenHeight(1000),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: manager.getTheme().backgroundColor,
                ),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 20, left: 30),
                        child: Row(children: [
                          Opacity(
                              opacity: 0.5,
                              child: Text(
                                "Localisation",
                                style: TextStyle(fontSize: 15),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: getProportionateScreenHeight(50)),
                            child:
                          Opacity(
                              opacity: 0.5,
                              child: Text(
                                "Ouvert ?",
                                style: TextStyle(fontSize: 15),

                              ))),
                          Container(
                            width: 20,
                            height: getProportionateScreenHeight(10),
                            margin: EdgeInsets.only(left: getProportionateScreenHeight(10)),
                            padding: EdgeInsets.only(top: getProportionateScreenHeight(10), right: getProportionateScreenHeight(20)),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color :Colors.red ),
                          ),
                        ])),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        widget.data.name,
                        softWrap: true,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 40),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("4 étoiles ",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),

                    Container(
                      height: getProportionateScreenHeight(160),
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: getProportionateScreenWidth(150),
                            height: getProportionateScreenHeight(200),
                            // color: Colors.white,
                            child: Text(widget.data.description),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      //mainAxisAlignment: MainAxisAlignment.center,
                      child: Column(
                        children: [
                          Text(
                            "Commentaires",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          CommentVerifier(data: widget.data),
                          if (comments.length == 0)
                            Text(
                                "Aucun commentaire pour le moment, soyez le premier  !")
                          else
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Text(comments[index].text),
                                );
                              },
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
