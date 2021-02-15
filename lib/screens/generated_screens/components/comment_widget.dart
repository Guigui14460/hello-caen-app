import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'button.dart';
import 'small_profile.dart';
import 'subcomment_widget.dart';
import '../../../model/comment.dart';
import '../../../model/sub_comment.dart';
import '../../../model/user_account.dart';
import '../../../model/database/comment_model.dart';
import '../../../model/database/sub_comment_model.dart';
import '../../../model/database/user_model.dart';
import '../../../services/size_config.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final Function onPressedToUpdate, onPressedToDelete;
  const CommentWidget({
    Key key,
    @required this.comment,
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
                comment: comment,
                onPressedToUpdate: onPressedToUpdate,
                onPressedToDelete: onPressedToDelete,
              );
            },
            future: UserModel().getById(comment.authorId),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: comment.rating,
                glow: false,
                ignoreGestures: true,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(comment.text),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          SmallButton(
            name: "Ajouter un sous-commentaire",
            icon: Icon(Icons.add),
            onPressed: _addSubComment,
          ),
          _buildSubCommentsWidget(),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  Widget _buildSubCommentsWidget() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<SubComment>> snap) {
        if (snap.connectionState == ConnectionState.none || !snap.hasData) {
          return Text("Erreur lors du chargement des sous-commentaires");
        }
        if (snap.data.length == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Aucun sous-commentaire")],
          );
        }
        return ExpansionTile(
          leading: Icon(Icons.mode_comment),
          title:
              Text("Sous-commentaires (" + snap.data.length.toString() + ")"),
          children: List<Widget>.generate(
            snap.data.length,
            (index) {
              return SubCommentWidget(
                subcomment: snap.data[index],
                onPressedToDelete: _updateSubComment,
                onPressedToUpdate: _deleteSubComment,
              );
            },
          ),
        );
      },
      future: SubCommentModel().where("comment",
          isEqualTo: CommentModel().getDocumentReference(comment.id)),
    );
  }

  void _addSubComment() {
    // TODO: faire corps
  }

  void _updateSubComment() {
    // TODO: faire corps
  }

  void _deleteSubComment() {
    // TODO: faire corps
  }
}
