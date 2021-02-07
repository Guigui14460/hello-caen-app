import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_caen/components/new_comment_box.dart';
import 'package:hello_caen/model/commerce.dart';
import 'package:hello_caen/screens/sign_in/sign_in_screen.dart';
import 'package:hello_caen/screens/sign_up/sign_up_screen.dart';
import 'package:hello_caen/services/size_config.dart';
import 'package:hello_caen/services/user_manager.dart';
import 'package:provider/provider.dart';

import '../constants.dart';


class CommentVerifier extends StatefulWidget {


  final Commerce data;

  const CommentVerifier({Key key, this.data})
      : super(key: key);




  @override
  _CommentVerifierState createState() => _CommentVerifierState();
}

class _CommentVerifierState extends State<CommentVerifier> {



  Widget build(BuildContext context) {
    UserManager userManager = Provider.of<UserManager>(context);

   return userManager.isLoggedIn() ? NewCommentBox(data: widget.data) : buildSignInSignUpWidget(context);
  }



  Widget buildSignInSignUpWidget(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SignInScreen())),
                child: Text(
                  "Connectez-vous",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: getProportionateScreenWidth(20),
                  ),
                )),
            Text(
              " ou ",
              style: TextStyle(fontSize: getProportionateScreenWidth(20)),
            ),
            GestureDetector(
                onTap: () => Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SignUpScreen())),
                child: Text(
                  "incrivez-vous",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: getProportionateScreenWidth(20)),
                )),
          ],
        ),
        Text("pour pouvoir, vous-aussi donner votre avis !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: getProportionateScreenWidth(20))),
      ],
    );

  }

}