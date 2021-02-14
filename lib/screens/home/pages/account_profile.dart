import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../account_parameters/account_parameters_screen.dart';
import '../../admin/home/home_screen.dart';
import '../../pro/home/home_screen.dart';
import '../../sign_in/sign_in_screen.dart';
import '../../../components/avatar.dart';
import '../../../components/custom_dialog.dart';
import '../../../model/database/user_model.dart';
import '../../../model/user_account.dart';
import '../../../services/firebase_settings.dart';
import '../../../services/location_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/size_config.dart';
import '../../../services/storage_manager.dart';
import '../../../services/theme_manager.dart';
import '../../../services/user_manager.dart';

class AccountProfilePage extends StatefulWidget {
  final Widget associatedScreen;
  AccountProfilePage(this.associatedScreen, {Key key}) : super(key: key);

  @override
  _AccountProfilePageState createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {
  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = Provider.of<ThemeManager>(context);
    UserManager userManager = Provider.of<UserManager>(context);
    bool isDarkMode = themeManager.isDarkMode();
    bool notificationsEnabled =
        Provider.of<NotificationService>(context).isEnabled();
    bool locationEnabled = Provider.of<LocationService>(context).isEnabled();

    TextStyle style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: getProportionateScreenWidth(24));

    ImageProvider<Object> picture = userManager.isLoggedIn() &&
            userManager.getLoggedInUser().profilePicture != null &&
            userManager.getLoggedInUser().profilePicture != ""
        ? NetworkImage(userManager.getLoggedInUser().profilePicture)
        : AssetImage("assets/images/no-picture.png");

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getProfilePicture(context, picture),
            SizedBox(height: getProportionateScreenHeight(10)),
            (userManager.isLoggedIn()
                ? Text(
                    userManager.getLoggedInUser().firstName +
                        " " +
                        userManager.getLoggedInUser().lastName,
                    style: style,
                  )
                : Text(
                    "Non connecté",
                    style: style,
                  )),
            SizedBox(height: getProportionateScreenHeight(10)),
            (!userManager.isLoggedIn()
                ? Column(
                    children: [
                      _getButton(
                        title: "Se connecter",
                        iconData: Icons.login,
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SignInScreen())),
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  )
                : SizedBox()),
            (userManager.isLoggedIn()
                ? (userManager.getLoggedInUser().proAccount
                    ? Column(
                        children: [
                          _getButton(
                              title: "Gestion de vos commerces",
                              iconData: Icons.view_list,
                              onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ProHomeScreen())),
                              isDarkMode: isDarkMode),
                          SizedBox(height: getProportionateScreenHeight(20)),
                        ],
                      )
                    : (userManager.getLoggedInUser().adminAccount
                        ? Column(
                            children: [
                              _getButton(
                                  title: "Administration",
                                  iconData: Icons.view_list,
                                  onTap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              AdminHomeScreen())),
                                  isDarkMode: isDarkMode),
                              SizedBox(
                                  height: getProportionateScreenHeight(20)),
                            ],
                          )
                        : SizedBox()))
                : SizedBox()),
            (userManager.isLoggedIn()
                ? Column(
                    children: [
                      _getButton(
                        title: "Paramètres du compte",
                        iconData: Icons.settings,
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AccountParametersScreen(
                              firstTime: false,
                            ),
                          ),
                        ),
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  )
                : SizedBox()),
            _getButton(
              title: locationEnabled
                  ? "Désactiver la localisation"
                  : "Activer la localisation",
              iconData: locationEnabled
                  ? Icons.place_rounded
                  : Icons.location_off_rounded,
              onTap: locationEnabled
                  ? () => _showDeactivateLocationDialog(context)
                  : () => _activateLocation(context),
              isDarkMode: isDarkMode,
              showRightArrow: locationEnabled,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Hero(
                tag: "notifications",
                child: _getButton(
                  title: notificationsEnabled
                      ? "Désactiver les notifications"
                      : "Activer les notifications",
                  iconData: notificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  onTap: notificationsEnabled
                      ? () => _showDeactivateNotificationsDialog(context)
                      : () => _activateNotifications(context),
                  isDarkMode: isDarkMode,
                  showRightArrow: notificationsEnabled,
                )),
            SizedBox(height: getProportionateScreenHeight(20)),
            _getButton(
              title: "Changer de mode",
              iconData: isDarkMode ? Icons.brightness_2 : Icons.brightness_5,
              onTap: themeManager.toggleThemeMode,
              isDarkMode: isDarkMode,
              showRightArrow: false,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            (userManager.isLoggedIn()
                ? Column(
                    children: [
                      _getButton(
                        title: "Se déconnecter",
                        iconData: Icons.logout,
                        onTap: userManager.logoutUser,
                        isDarkMode: isDarkMode,
                        lightModeBackgroundcolor: Colors.amberAccent[700],
                        darkModeBackgroundcolor: Colors.amberAccent[700],
                        lightModeForegroundcolor: Colors.white,
                        showRightArrow: false,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  )
                : SizedBox()),
            _getButton(
              title: "Supprimer les données locales",
              iconData: Icons.delete,
              onTap: () async {
                await StorageManager.deleteStorage().then((value) {
                  if (value == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Données locales détruites")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Erreur lors de la suppression des données locales")));
                  }
                });
              },
              lightModeBackgroundcolor: Colors.blue[700],
              darkModeBackgroundcolor: Colors.blue[700],
              lightModeForegroundcolor: Colors.white,
              isDarkMode: isDarkMode,
              showRightArrow: false,
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            (userManager.isLoggedIn()
                ? Column(
                    children: [
                      _getButton(
                        title: "Supprimer le compte\ndéfinitivement",
                        iconData: Icons.delete_forever,
                        onTap: () => _showDeleteAccountDialog(context, picture),
                        isDarkMode: isDarkMode,
                        lightModeBackgroundcolor: Colors.red,
                        darkModeBackgroundcolor: Colors.red,
                        lightModeForegroundcolor: Colors.white,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _getProfilePicture(
      BuildContext context, ImageProvider<Object> picture) {
    return GestureDetector(
      onLongPress: () => _changeProfilePicture(context),
      child: Avatar(size: getProportionateScreenWidth(175), picture: picture),
    );
  }

  void _changeProfilePicture(BuildContext context) async {
    UserManager userManager = Provider.of<UserManager>(context, listen: false);
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          User user = userManager.getLoggedInUser();
          return CustomDialogBox(
            title: "Modifier votre image de profil",
            description:
                "Choisissez une nouvelle image de profil en deux clics !",
            text: "Choisir",
            onPressed: () async {
              try {
                PickedFile image =
                    await ImagePicker().getImage(source: ImageSource.gallery);
                await FirebaseSettings.instance.uploadFile(
                    image, context, "profiles-pictures", "${user.id}.jpg");
                await Future.delayed(Duration(seconds: 2));
                String url = await FirebaseSettings.instance.downloadLink(
                    FirebaseSettings.instance
                        .getStorage()
                        .ref("profiles-pictures/${user.id}.jpg"));
                user.profilePicture = url;
                await UserModel().update(user.id, user);
                userManager.updateLoggedInUser(user);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Erreur lors de l'envoi de la nouvelle image de profil")));
              }
              Navigator.pop(context);
            },
          );
        });
  }

  Widget _getButton(
      {String title,
      IconData iconData,
      VoidCallback onTap,
      Color lightModeBackgroundcolor = const Color(0xffe3e3e3),
      Color darkModeBackgroundcolor = const Color(0xff515151),
      Color lightModeForegroundcolor = Colors.black,
      Color darkModeForegroundcolor = Colors.white,
      bool isDarkMode = false,
      bool showRightArrow = true}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color:
              isDarkMode ? darkModeBackgroundcolor : lightModeBackgroundcolor,
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(12),
            vertical: getProportionateScreenWidth(12),
          ),
          child: (showRightArrow
              ? Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          iconData,
                          color: isDarkMode
                              ? darkModeForegroundcolor
                              : lightModeForegroundcolor,
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Text(
                          title,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(17),
                            color: isDarkMode
                                ? darkModeForegroundcolor
                                : lightModeForegroundcolor,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: isDarkMode
                          ? darkModeForegroundcolor
                          : lightModeForegroundcolor,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Icon(
                      iconData,
                      color: isDarkMode
                          ? darkModeForegroundcolor
                          : lightModeForegroundcolor,
                    ),
                    SizedBox(width: getProportionateScreenWidth(10)),
                    Text(
                      title,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(17),
                        color: isDarkMode
                            ? darkModeForegroundcolor
                            : lightModeForegroundcolor,
                      ),
                    ),
                  ],
                )),
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, ImageProvider<Object> picture) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomDialogBox(
          title: "Supprimer votre compte",
          description:
              "La suppression de votre compte est irréversible et vos informations ne pourront plus être récupérées. Confirmez-vous la suppression ?",
          img: picture,
          text: "Confirmer",
          onPressed: () async {
            User user = dialogContext.read<UserManager>().getLoggedInUser();
            Navigator.pop(dialogContext);
            try {
              await dialogContext.read<UserManager>().deleteUser();
            } catch (e) {
              Navigator.pushNamed(dialogContext, SignInScreen.routeName);
              if (dialogContext
                  .read<UserManager>()
                  .getLoggedInUser()
                  .equals(user)) {
                await dialogContext.read<UserManager>().deleteUser();
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Veuillez vous connecter avec le compte avec lequel vous avez commencé la suppression."),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  void _activateLocation(BuildContext context) async {
    await Provider.of<LocationService>(context, listen: false).enableService();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Localisation activée"),
      ),
    );
  }

  void _showDeactivateLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Désactiver la localisation",
          description:
              "Vous ne pourrez plus avoir les commerçants proche de vous dans l'onglet \"Localisation\". Confirmez-vous la désactivation ?",
          text: "Confirmer",
          onPressed: () async {
            await Provider.of<LocationService>(context, listen: false)
                .disableService();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Localisation désactivée"),
              ),
            );
          },
        );
      },
    );
  }

  void _activateNotifications(BuildContext context) async {
    await Provider.of<NotificationService>(context, listen: false)
        .enableService();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notifications activées"),
      ),
    );
  }

  void _showDeactivateNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Désactiver les notifications",
          description:
              "Vous ne recevrez plus de notifications de bon plans. Confirmez-vous la désactivation ?",
          text: "Confirmer",
          onPressed: () async {
            await Provider.of<NotificationService>(context, listen: false)
                .disableService();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Notifications désactivées"),
              ),
            );
          },
        );
      },
    );
  }
}
