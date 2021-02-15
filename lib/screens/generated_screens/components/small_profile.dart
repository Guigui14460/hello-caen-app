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
        _buildPopupMenuButton(userManager),
        // (userManager.getLoggedInUser().id == user.id
        //     ? IconButton(
        //         padding: EdgeInsets.zero,
        //         alignment: Alignment.topRight,
        //         icon: Icon(
        //           Icons.edit,
        //           color: Colors.blue,
        //         ),
        //         onPressed: onPressedToUpdate,
        //       )
        //     : Container()),
        // (userManager.getLoggedInUser().id == user.id
        //     ? IconButton(
        //         padding: EdgeInsets.zero,
        //         alignment: Alignment.topRight,
        //         icon: Icon(
        //           Icons.delete,
        //           color: Colors.red,
        //         ),
        //         onPressed: onPressedToDelete,
        //       )
        //     : Container()),
      ],
    );
  }

  Widget _buildPopupMenuButton(UserManager userManager) {
    bool isOwner = userManager.getLoggedInUser().id == user.id;
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 1:
            // TODO: report comment
            break;
          case 2:
            onPressedToUpdate();
            break;
          case 3:
            onPressedToDelete();
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        (!isOwner
            ? PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.report),
                    SizedBox(width: 8),
                    Text("Signaler"),
                  ],
                ),
                value: 1,
              )
            : null),
        (isOwner
            ? PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Modifier",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                value: 2,
              )
            : null),
        (isOwner
            ? PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Supprimer",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                value: 3,
              )
            : null),
      ],
    );
  }
}
