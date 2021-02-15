import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import 'components/button.dart';
import 'components/comment_widget.dart';
import 'components/create_update_delete_comment_modal.dart';
import '../../components/app_bar.dart';
import '../../components/map_object.dart';
import '../../helper/rating_and_comment_count.dart';
import '../../model/comment.dart';
import '../../model/commerce.dart';
import '../../model/rating.dart';
import '../../model/user_account.dart';
import '../../model/database/comment_model.dart';
import '../../model/database/commerce_model.dart';
import '../../model/database/rating_model.dart';
import '../../model/database/user_model.dart';
import '../../services/size_config.dart';
import '../../services/theme_manager.dart';
import '../../services/user_manager.dart';

/// Screen displayed by default for all users.
class GeneratedStoreScreen extends StatefulWidget {
  /// Name of the route where is the screen.
  static final String routeName = "/GeneratedStore";

  final Commerce data;
  final RatingAndCommentCount rating;

  const GeneratedStoreScreen(
      {Key key, @required this.data, @required this.rating})
      : super(key: key);

  @override
  _GeneratedStoreScreenState createState() => _GeneratedStoreScreenState();
}

class _GeneratedStoreScreenState extends State<GeneratedStoreScreen> {
  Comment _myComment;
  Rating _myRating;
  bool _errorLoadingData = false;

  @override
  void initState() {
    UserManager userManager = UserManager.instance;
    var commerceRef = CommerceModel().getDocumentReference(widget.data.id);
    RatingModel()
        .whereLinked("commerce", isEqualTo: commerceRef)
        .executeCurrentLinkedQueryRequest()
        .then((value) {
      List<Rating> ratings = value
          .where(
              (element) => element.authorId == userManager.getLoggedInUser().id)
          .toList();
      if (this.mounted && ratings.length == 1) {
        setState(() {
          _myRating = ratings[0];
        });
      }
    }).catchError((error) {
      if (this.mounted) {
        setState(() {
          _errorLoadingData = true;
        });
      }
    });
    CommentModel()
        .whereLinked("commerce", isEqualTo: commerceRef)
        .whereLinked("author",
            isEqualTo: UserModel()
                .getDocumentReference(userManager.getLoggedInUser().id))
        .executeCurrentLinkedQueryRequest()
        .then((value) {
      List<Comment> comments = value
          .where(
              (element) => element.authorId == userManager.getLoggedInUser().id)
          .toList();
      if (this.mounted && comments.length == 1) {
        setState(() {
          _myComment = comments[0];
        });
      }
    }).catchError((error) {
      if (this.mounted) {
        setState(() {
          _errorLoadingData = true;
        });
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    ThemeManager themeManager = Provider.of<ThemeManager>(context);
    UserManager userManager = Provider.of<UserManager>(context);
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          actions: [
            userManager
                    .getLoggedInUser()
                    .favoriteCommerceIds
                    .contains(widget.data.id)
                ? Icon(Icons.bookmark)
                : Icon(Icons.bookmark_outline)
          ],
          actionsCallback: [
            () async {
              User user = userManager.getLoggedInUser();
              if (user.favoriteCommerceIds.contains(widget.data.id)) {
                user.favoriteCommerceIds.remove(widget.data.id);
              } else {
                user.favoriteCommerceIds.add(widget.data.id);
              }
              await UserModel().updateFields(
                user.id,
                user,
                ['favoriteCommerces'],
                [user.favoriteCommerceIds],
              );
              userManager.updateLoggedInUser(user);
            }
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: getProportionateScreenHeight(300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Hero(
                  tag: widget.data.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: widget.data.getImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 220),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: themeManager.getTheme().backgroundColor,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                      ),
                      child: Text(
                        widget.data.name,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    (widget.rating.ratingMean.isNaN
                        ? Text("Aucune note encore attribuée")
                        : RatingBarIndicator(
                            rating: widget.rating.ratingMean,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: getProportionateScreenHeight(20)),
                        _buildSection(
                          "Description",
                          Text(
                            widget.data.description,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        _buildSection(
                          "Horaires",
                          Text(
                            widget.data.timetables,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        _buildSection(
                          "Localisation dans Caen",
                          MapObject(
                            height: 250,
                            initialZoom: 11.5,
                            maxZoom: 19,
                            initialLocation: LatLng(
                                widget.data.latitude, widget.data.longitude),
                            onTap: (LatLng location) {},
                            slideOnBoundaries: true,
                          ),
                        ),
                        _buildMyComment(context, userManager),
                        _buildOtherComment(userManager),
                      ],
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

  Widget _buildSection(String title, Widget content) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(4)),
          content,
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  Widget _buildMyComment(BuildContext context, UserManager userManager) {
    if (_myComment == null) {
      return SmallButton(
        name: "Ajouter un commentaire",
        onPressed: () => addCommentDialog(
          context,
          (String content, double rating) async {
            Comment comment = Comment(
                commerceId: widget.data.id,
                dateAdded: DateTime.now(),
                dateModified: DateTime.now(),
                rating: rating,
                text: content,
                authorId: userManager.getLoggedInUser().id);
            Rating ratingObj = Rating(
                rating: rating,
                commerceId: widget.data.id,
                authorId: userManager.getLoggedInUser().id);
            comment.id = await CommentModel().create(comment);
            ratingObj.id = await RatingModel().create(ratingObj);
            Navigator.pop(context);
            if (this.mounted) {
              setState(() {
                _myComment = comment;
                _myRating = ratingObj;
              });
            }
          },
        ),
        icon: Icon(Icons.add_comment),
      );
    }
    return CommentWidget(
      comment: _myComment,
      onPressedToUpdate: () => updateCommentDialog(
        context,
        (_errorLoadingData
            ? null
            : (String content, double rating) async {
                _myComment.text = content;
                _myComment.rating = rating;
                _myRating.rating = rating;
                await CommentModel()
                    .update(_myComment.id, _myComment)
                    .then((comment) async {
                  await RatingModel()
                      .update(_myRating.id, _myRating)
                      .then((rating) {
                    if (this.mounted && comment && rating) {
                      setState(() {
                        _myComment = _myComment;
                        _myRating = _myRating;
                      });
                      Navigator.pop(context);
                    }
                  });
                });
              }),
        _myComment,
      ),
      onPressedToDelete: (_errorLoadingData
          ? null
          : () => deleteCommentDialog(context, () async {
                await CommentModel()
                    .delete(_myComment.id)
                    .then((comment) async {
                  await RatingModel().delete(_myRating.id).then((rating) {
                    if (this.mounted && comment && rating) {
                      setState(() {
                        _myComment = null;
                        _myRating = null;
                      });
                      Navigator.pop(context);
                    }
                  });
                });
              })),
    );
  }

  Widget _buildOtherComment(UserManager userManager) {
    return FutureBuilder(
      future: CommentModel()
          .whereLinked("commerce",
              isEqualTo: CommerceModel().getDocumentReference(widget.data.id))
          .orderByLinked("dateAdded")
          .executeCurrentLinkedQueryRequest()
          .then((value) {
        List<Comment> comments = value
            .where((element) =>
                element.authorId != userManager.getLoggedInUser().id)
            .toList();
        return comments;
      }),
      builder: (_, AsyncSnapshot<List<Comment>> snap) {
        if (snap.connectionState == ConnectionState.none || !snap.hasData) {
          return Text("Erreur lors du chargement des commentaires");
        }
        return ExpansionTile(
          leading: Icon(Icons.comment),
          title:
              Text("Autres commentaires (" + snap.data.length.toString() + ")"),
          children: (snap.data.length > 0
              ? List<Widget>.generate(snap.data.length, (index) {
                  return CommentWidget(
                    comment: snap.data[index],
                    onPressedToDelete: null,
                    onPressedToUpdate: null,
                  );
                })
              : [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Aucun autre commentaire"),
                  ),
                ]),
        );
      },
    );
  }
}
