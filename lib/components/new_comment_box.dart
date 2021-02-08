import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/comment.dart';
import '../model/commerce.dart';
import '../model/database/comment_model.dart';
import '../model/user_account.dart';
import '../services/size_config.dart';
import '../services/user_manager.dart';

class NewCommentBox extends StatefulWidget {
  final Commerce data;
  const NewCommentBox({Key key, this.data}) : super(key: key);

  @override
  _NewCommentBoxState createState() => _NewCommentBoxState();
}

class _NewCommentBoxState extends State<NewCommentBox> {
  User _user;

  Widget build(BuildContext context) {
    if (this.mounted) {
      setState(() {
        _user = Provider.of<UserManager>(context).getLoggedInUser();
      });
    }
    return Column(
      children: [
        Text(
          "Un avis ? Exprimez vous  !",
          style: TextStyle(fontSize: 12),
        ),
        Row(
          children: [
            Container(
              width: getProportionateScreenHeight(50),
              height: getProportionateScreenHeight(50),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_user.profilePicture),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
            ),
            SizedBox(width: getProportionateScreenWidth(10)),
            Expanded(
              child: Container(
                height: getProportionateScreenHeight(75),
                //color: Colors.black,
                child: TextFormField(
                  onFieldSubmitted: (String value) async {
                    //Send To Batadase Goes Hereeeeeeeeeeeeeeeeeeeeeeeeeeeee  !!!!!         <-----------------------------------------------------------------
                    await CommentModel().create(new Comment(
                        commerceId: widget.data.id,
                        dateAdded: new DateTime.now(),
                        dateModified: new DateTime.now(),
                        rating: 4.0,
                        text: value,
                        authorId: _user.id));
                  },
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
