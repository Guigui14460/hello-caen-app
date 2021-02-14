import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar.dart';
import '../../components/map_object.dart';
import '../../helper/rating_and_comment_count.dart';
import '../../model/comment.dart';
import '../../model/commerce.dart';
import '../../model/user_account.dart';
import '../../model/database/comment_model.dart';
import '../../model/database/commerce_model.dart';
import '../../model/database/user_model.dart';
import '../../services/size_config.dart';
import '../../services/theme_manager.dart';
import '../../services/user_manager.dart';
import '../../utils.dart';

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
  User _owner;

  @override
  void initState() {
    UserModel().getById(widget.data.ownerId).then((value) {
      if (this.mounted) {
        setState(() {
          _owner = value;
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
                    RatingBar.builder(
                      initialRating: widget.rating.ratingMean,
                      glow: false,
                      ignoreGestures: true,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
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
                        // TODO: ajouter ici espace pour commenter
                        FutureBuilder(
                          future: CommentModel().where("commerce",
                              isEqualTo: CommerceModel()
                                  .getDocumentReference(widget.data.id)),
                          builder: (_, AsyncSnapshot<List<Comment>> snap) {
                            if (snap.connectionState == ConnectionState.none ||
                                !snap.hasData) {
                              return Text(
                                  "Erreur lors du chargement des commentaires");
                            }
                            return ExpansionTile(
                              leading: Icon(Icons.comment),
                              title: Text("Commentaires"),
                              children: (snap.data.length > 0
                                  ? List<Widget>.generate(snap.data.length,
                                      (index) {
                                      return _buildSingleComment(
                                        userManager,
                                        snap.data[index],
                                      );
                                    })
                                  : [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: Text("Aucun commentaire"),
                                      ),
                                    ]),
                            );
                          },
                        ),
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

  Widget _buildSingleComment(UserManager userManager, Comment comment) {
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
              return _buildSmallProfile(userManager, snap.data, comment);
            },
            future: UserModel().getById(comment.authorId),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding:
                EdgeInsets.only(left: getProportionateScreenWidth(30) + 15),
            child: Text(
              (comment.dateAdded.isAtSameMomentAs(comment.dateModified)
                  ? "Ajouté le" + convertDatetimeToString(comment.dateAdded)
                  : "Modifié le " +
                      convertDatetimeToString(comment.dateModified)),
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow[600],
                size: 19,
              ),
              Text("${comment.rating}/5"),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(comment.text),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                  ),
                  Text(
                    "Ajouter un sous-commentaire",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
        ],
      ),
    );
  }

  Widget _buildSmallProfile(
      UserManager userManager, User user, Comment comment) {
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
          child: Text(
            user.firstName +
                " " +
                user.lastName +
                (user.id == _owner.id ? " (propriétaire)" : ""),
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
        (userManager.getLoggedInUser().id == user.id
            ? IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: () {},
              )
            : Container()),
        (userManager.getLoggedInUser().id == user.id
            ? IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {},
              )
            : Container()),
      ],
    );
  }

  void _addSubComment() {}

  void _modifySubComment() {}
}
