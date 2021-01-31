import 'package:flutter/material.dart';

import '../../../components/app_bar.dart';
import '../../../model/comment.dart';
import '../../../model/commerce.dart';
import '../../../model/database/comment_model.dart';
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
    CommentModel().getMultipleByIds(widget.data.commentIds).then((value) {
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
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.data.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40))
                        ],
                      ),
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
                height: getProportionateScreenHeight(200),
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: getProportionateScreenWidth(150),
                      height: getProportionateScreenHeight(200),
                      //color : Colors.amber,
                      child: Text(widget.data.description),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: getProportionateScreenWidth(150),
                      height: getProportionateScreenHeight(200),
                      color: Colors.amber,
                      child: Text(widget.data.timetables),
                    )
                  ],
                ),
              ),
              Container(
                width: getProportionateScreenWidth(1000),
                height: getProportionateScreenHeight(130),
                margin: EdgeInsets.only(top: 10),
                //mainAxisAlignment: MainAxisAlignment.center,
                child: Column(
                  children: [
                    Text(
                      "Commentaires",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    if (widget.data.commentIds.length == 0)
                      Text(
                          "Aucun commentaire pour le moment, soyez le premier  !")
                    else
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.data.commentIds.length,
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
