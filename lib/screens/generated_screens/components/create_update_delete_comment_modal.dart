import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'comment_form.dart';
import 'needed_sing_in.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../../components/modal_box.dart';
import '../../../model/comment.dart';
import '../../../services/user_manager.dart';

void addCommentDialog(
    BuildContext context, Function(String content, double rating) onPressed) {
  UserManager userManager = Provider.of<UserManager>(context, listen: false);
  CommentForm form = CommentForm();
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return ModalBox(
        title: "Ajouter un commentaire",
        textButton: (userManager.isLoggedIn() ? "Ajouter" : "Se connecter"),
        widget: (userManager.isLoggedIn()
            ? form
            : NeededSignIn(
                text:
                    "Vous devez être connecté pour rédiger une critique et attribuer une note sur ce commerce",
              )),
        onPressed: (userManager.isLoggedIn()
            ? () {
                if (!form.error) {
                  onPressed(form.initialValue, form.initialRating);
                }
              }
            : () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              }),
      );
    },
  );
}

void updateCommentDialog(BuildContext context,
    Function(String content, double rating) onPressed, Comment comment) {
  UserManager userManager = Provider.of<UserManager>(context, listen: false);
  CommentForm form = CommentForm(
    initialValue: comment.text,
    initialRating: comment.rating,
  );
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return ModalBox(
        title: "Modifier votre commentaire",
        textButton: (userManager.isLoggedIn() ? "Modifier" : "Se connecter"),
        widget: (userManager.isLoggedIn()
            ? form
            : NeededSignIn(
                text:
                    "Vous devez être connecté pour modifier votre critique et note de ce commerce",
              )),
        onPressed: (userManager.isLoggedIn()
            ? () {
                if (!form.error) {
                  onPressed(form.initialValue, form.initialRating);
                }
              }
            : () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              }),
      );
    },
  );
}

void deleteCommentDialog(BuildContext context, Function() onPressed) {
  UserManager userManager = Provider.of<UserManager>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return ModalBox(
        title: "Supprimer votre commentaire",
        textButton: (userManager.isLoggedIn() ? "Confirmer" : "Se connecter"),
        widget: Text(
            "Êtes-vous sûr de vouloir supprimer votre commentaire ? Cela entrainera la suppression de votre note ainsi de tous les sous-commentaires. Confirmer ?"),
        onPressed: (userManager.isLoggedIn()
            ? onPressed
            : () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );
              }),
      );
    },
  );
}
