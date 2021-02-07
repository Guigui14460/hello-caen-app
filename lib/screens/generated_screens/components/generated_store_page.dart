import 'package:flutter/material.dart';
import 'package:hello_caen/components/comment_verifier.dart';
import 'package:hello_caen/components/new_comment_box.dart';

import '../../../components/app_bar.dart';
import '../../../model/comment.dart';
import '../../../model/commerce.dart';
import '../../../model/database/comment_model.dart';
import '../../../model/database/commerce_model.dart';
import '../../../services/size_config.dart';

class GeneratedStorePage extends StatefulWidget {
  final Commerce data;

  const GeneratedStorePage({Key key, @required this.data}) : super(key: key);
  @override
  _GeneratedStorePageState createState() => _GeneratedStorePageState();
}

class _GeneratedStorePageState extends State<GeneratedStorePage> {
  Widget build(BuildContext context) {
    print(widget.data);
    List<Comment> comments = [];
    CommentModel()
        .where("commerce",
            isEqualTo: CommerceModel().getDocumentReference(widget.data.id))
        .then((value) {
      setState(() {
        comments = value;
      });
    });
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: getProportionateScreenWidth(1000),
                height: getProportionateScreenHeight(130),
                margin: EdgeInsets.only(top: 10, left: 20),
                child: Column(
                  children: [
                    Container(
                      child: Text(widget.data.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("4 étoiles ",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: getProportionateScreenWidth(330),
                height: getProportionateScreenHeight(200),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.data.imageLink),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
              Container(
                width: getProportionateScreenWidth(1000),
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
                    Container(
                      width: getProportionateScreenWidth(150),
                      height: getProportionateScreenHeight(200),
                      color: Colors.redAccent,
                      child: Container(
                        // margin: EdgeInsets.only(top: 65, left: 55),
                        child: Center(
                          child: Text(
                            widget.data.timetables,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: getProportionateScreenWidth(1000),
                height: getProportionateScreenHeight(130),
                margin: EdgeInsets.only(top: 10),
                //mainAxisAlignment: MainAxisAlignment.center,
                  child:Column(
                  children: [
                    Text(
                      "Commentaires",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    CommentVerifier(data: widget.data),
                    if (comments.length == 0)
                      Text("Aucun commentaire pour le moment, soyez le premier  !")
                    else
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: getProportionateScreenWidth(1000),
                            height: getProportionateScreenHeight(100),
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
      ),
    );
  }
}
