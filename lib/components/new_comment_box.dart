import 'package:flutter/material.dart';
import 'package:hello_caen/model/comment.dart';
import 'package:hello_caen/model/commerce.dart';
import 'package:hello_caen/model/database/comment_model.dart';
import 'package:hello_caen/services/firebase_settings.dart';
import 'package:hello_caen/services/size_config.dart';


class NewCommentBox extends StatefulWidget {

  final Commerce data;

  const NewCommentBox({Key key, this.data})
      : super(key: key);

  @override
  _NewCommentBoxState createState() => _NewCommentBoxState();


}

class _NewCommentBoxState extends State<NewCommentBox> {

  Widget build(BuildContext context) {
  return Container(
      width: getProportionateScreenWidth(1000),
      height: getProportionateScreenHeight(75),
      child: Row(
        children : [
          Container(
            width: getProportionateScreenWidth(75),
            height: getProportionateScreenHeight(75),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(FirebaseSettings.instance.getAuth().currentUser.photoURL),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            //child:  ,
          ),
          Container(
            width: getProportionateScreenWidth(300),
            height: getProportionateScreenHeight(80),
            //color: Colors.black,
            child: Column(children: [
              Text("Un avis ? Exprimez vous  !",style: TextStyle(fontSize: 12),),
              TextFormField(
                onFieldSubmitted: (String value) async {
                  print(value);
                  //Send To Batadase Goes Hereeeeeeeeeeeeeeeeeeeeeeeeeeeee  !!!!!         <-----------------------------------------------------------------
                  await CommentModel().create(new Comment(commerceId: widget.data.id, dateAdded: new DateTime.now(), dateModified: new DateTime.now(), rating: 4.0, text: value, authorId: FirebaseSettings.instance.getAuth().currentUser.tenantId ));

                },
              ),
              ]
            )
          )




        ]
      )
    );
  }
}