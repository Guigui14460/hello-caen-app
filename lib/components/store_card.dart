import 'package:flutter/material.dart';
import 'package:hello_caen/model/database/user_model.dart';
import 'package:hello_caen/model/user_account.dart';
import 'package:hello_caen/services/user_manager.dart';
import 'package:provider/provider.dart';

import '../model/commerce.dart';
import '../model/database/comment_model.dart';
import '../model/database/commerce_model.dart';
import '../services/size_config.dart';

class StoreCard extends StatelessWidget {
  final Commerce commerce;
  final double width, height;
  final String smallTitle;
  final bool showComments;
  final VoidCallback onTap;
  const StoreCard({
    Key key,
    @required this.commerce,
    @required this.width,
    @required this.height,
    @required this.onTap,
    this.smallTitle,
    this.showComments = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<UserManager>(context);
    CommentModel()
        .where("commerce",
            isEqualTo: CommerceModel().getDocumentReference(commerce.id))
        .then((value) {
      this.commerce.setComments(value);
    });
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenHeight(20)),
      child: GestureDetector(
        onTap: this.onTap,
        child: SizedBox(
          width: getProportionateScreenWidth(this.width),
          height: getProportionateScreenHeight(this.height),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Hero(
                  tag: this.commerce.id,
                  child: Image.network(
                    this.commerce.imageLink,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF343434).withOpacity(0.7),
                          Color(0xFF343434).withOpacity(0.55),
                        ]),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(15),
                      vertical: getProportionateScreenWidth(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (this.smallTitle != null
                            ? Text(
                                this.smallTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : SizedBox()),
                        Row(
                          children: [
                            Text(
                              this.commerce.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getProportionateScreenWidth(24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            (userManager.isLoggedIn()
                                ? GestureDetector(
                                    child: Icon(
                                      userManager
                                              .getLoggedInUser()
                                              .favoriteCommerceIds
                                              .contains(commerce.id)
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: Colors.white,
                                    ),
                                    onTap: () async {
                                      User user = userManager.getLoggedInUser();
                                      if (user.favoriteCommerceIds
                                          .contains(commerce.id)) {
                                        user.favoriteCommerceIds
                                            .remove(commerce.id);
                                      } else {
                                        user.favoriteCommerceIds
                                            .add(commerce.id);
                                      }
                                      await UserModel().updateFields(
                                        user.id,
                                        user,
                                        ['favoriteCommerces'],
                                        [user.favoriteCommerceIds],
                                      );
                                      userManager.updateLoggedInUser(user);
                                    },
                                  )
                                : Container()),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[600],
                              size: 19,
                            ),
                            Text(
                              (this.commerce.getRating().isNaN
                                  ? "Aucune note"
                                  : "${this.commerce.getRating()}/5"),
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(),
                            (this.showComments
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      Text(
                                        " " +
                                            (this.commerce.comments.isEmpty
                                                ? "Aucun commentaire"
                                                : "${this.commerce.comments.length}"),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )
                                : SizedBox()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
