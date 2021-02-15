import 'package:flutter/material.dart';

import 'small_profile.dart';
import '../../../model/database/user_model.dart';
import '../../../model/sub_comment.dart';
import '../../../model/user_account.dart';
import '../../../services/size_config.dart';

class SubCommentWidget extends StatelessWidget {
  final SubComment subcomment;
  final Function onPressedToUpdate, onPressedToDelete;

  const SubCommentWidget({
    Key key,
    @required this.subcomment,
    @required this.onPressedToUpdate,
    @required this.onPressedToDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            builder: (_, AsyncSnapshot<User> snap) {
              if (snap.connectionState == ConnectionState.none ||
                  !snap.hasData) {
                return Text("Erreur lors du chargement du profil");
              }
              return SmallProfile(
                user: snap.data,
                comment: subcomment.convertToComment(),
                onPressedToUpdate: onPressedToUpdate,
                onPressedToDelete: onPressedToDelete,
              );
            },
            future: UserModel().getById(subcomment.authorId),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(subcomment.text),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }
}
