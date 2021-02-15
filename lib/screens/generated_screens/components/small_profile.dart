import 'package:flutter/material.dart';

import '../../../utils.dart';
import '../../../model/comment.dart';
import '../../../model/user_account.dart';
import '../../../services/size_config.dart';
import '../../../services/user_manager.dart';

// ignore: must_be_immutable
class SmallProfile extends StatelessWidget {
  final Comment comment;
  final User user;
  Function onPressedToUpdate, onPressedToDelete;

  SmallProfile({
    @required this.user,
    @required this.comment,
    Function onPressedToUpdate,
    Function onPressedToDelete,
  }) {
    this.onPressedToUpdate =
        (onPressedToUpdate == null ? () {} : onPressedToUpdate);
    this.onPressedToDelete =
        (onPressedToDelete == null ? () {} : onPressedToDelete);
  }

  @override
  Widget build(BuildContext context) {
    UserManager userManager = UserManager.instance;
    return Row(
      children: [
        Container(
          width: getProportionateScreenWidth(30),
          height: getProportionateScreenWidth(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            image: DecorationImage(
              image: NetworkImage(user.profilePicture),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.firstName + " " + user.lastName,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 3),
              Text(
                (comment.dateAdded.isAtSameMomentAs(comment.dateModified)
                    ? "Ajouté le" + convertDatetimeToString(comment.dateAdded)
                    : "Modifié le " +
                        convertDatetimeToString(comment.dateModified)),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        (userManager.getLoggedInUser().id == user.id
            ? IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.topRight,
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: onPressedToUpdate,
              )
            : Container()),
        (userManager.getLoggedInUser().id == user.id
            ? IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.topRight,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: onPressedToDelete,
              )
            : Container()),
      ],
    );
  }
}
