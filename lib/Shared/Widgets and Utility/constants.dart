import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helphub/imports.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:http/http.dart';
import 'ImageCompress.dart';

var kTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  hintStyle: TextStyle(height: 1.5, fontWeight: FontWeight.w300),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);

ShapeBorder kRoundedButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

ShapeBorder kBackButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
  ),
);

ShapeBorder kCardCircularShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(50)),
);

Widget kBackBtn = Icon(
  Icons.arrow_back_ios,
  // color: Colors.black54,
);

kopenPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => page,
    ),
  );
}

kBuzyPage({Color color = Colors.white}) {
  return Align(
    alignment: Alignment.center,
    child: SpinKitThreeBounce(
      color: color ?? Colors.white,
      size: 20.0,
    ),
  );
}

kbackBtn(BuildContext context) {
  Navigator.pop(context);
}

Future<String> getImage(
  bool mounted,
) async {
  String _path;
  File file = await takeCompressedPicture();
  if (file != null) _path = file.path;
  if (!mounted) return '';
  return _path;
}

ShapeBorder bordershape(double radius) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.horizontal(right: Radius.circular(radius ?? 15)),
  );
}

SnackBar ksnackBar(BuildContext context, String message, bool actionenabled,
    {Function onPressed}) {
  return SnackBar(
    duration: Duration(seconds: 2),
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    action: actionenabled
        ? SnackBarAction(
            label: "Open",
            onPressed: () {
              onPressed();
            })
        : null,
    backgroundColor: Theme.of(context).primaryColor,
  );
}

TextStyle infoStyle() {
  return TextStyle(fontSize: 17, fontWeight: FontWeight.w300);
}

Widget profileMaterialButton(Size size,
    {@required Function onPressed,
    @required String text,
    double elevation,
    double radius}) {
  return Container(
      width: size.height / 4,
      child: MaterialButton(
          color: Colors.white,
          shape: bordershape(radius ?? 10),
          elevation: elevation ?? 3,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Align(alignment: Alignment.centerLeft, child: Text(text)),
          ),
          onPressed: () {
            return onPressed();
          }));
}

Widget profileFlatButton(Size size,
    {@required Function onPressed,
    @required text,
    BorderRadiusGeometry radius}) {
  return InkWell(
    borderRadius: radius ?? BorderRadius.circular(0),
    onTap: () {
      onPressed();
    },
    child: Container(
      width: size.height / 4,
      height: size.height / 20 - 7,
      margin: EdgeInsets.only(left: 10),
      decoration:
          BoxDecoration(borderRadius: radius ?? BorderRadius.circular(0)),
      child: Align(alignment: Alignment.centerLeft, child: Text(text)),
    ),
  );
}

Card drawerProfileImageCard(Size size,
    {ImageProvider image, double elevation, double radius}) {
  return Card(
    elevation: elevation ?? 3,
    shape: bordershape(radius ?? 22),
    margin: EdgeInsets.all(0),
    child: Container(
      height: size.height / 3.5,
      width: size.height / 3.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(22)),
          image: DecorationImage(fit: BoxFit.cover, image: image)),
    ),
  );
}

TextStyle detailtitleStyle(context) {
  return TextStyle(
      fontSize: MediaQuery.of(context).size.width / 24,
      fontWeight: FontWeight.w700);
}

TextStyle detailvalueStyle(context) {
  return TextStyle(
      fontSize: MediaQuery.of(context).size.width / 24,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w300);
}

Widget drawerProfileInfo(Size size,
    {List<Widget> children, double elevation, double radius}) {
  return Card(
    margin: EdgeInsets.only(left: 0),
    shape: bordershape(radius ?? 15),
    elevation: elevation ?? 3,
    child: Container(
      width: size.height / 4,
      margin: EdgeInsets.only(left: 10, right: 0, top: 12, bottom: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children),
    ),
  );
}

Card drawerNameCard(Size size,
    {String user, String name, double elevation, double radius}) {
  return Card(
    margin: EdgeInsets.only(left: 0),
    shape: bordershape(radius ?? 15),
    elevation: elevation ?? 3,
    child: Container(
      width: size.height / 4,
      margin: EdgeInsets.only(left: 10, right: 0, top: 12, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(user,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 10,
          ),
          Text(name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    ),
  );
}

LayoutBuilder buildMenu({
  @required String user,
  @required String name,
  @required String imageUrl,
  @required String profileRoute,
  @required Function animateIcon,
  @required double elevation,
  @required double radius,
  @required List<Widget> infoChildren,
}) {
  LoginPageModel model = locator<LoginPageModel>();
  return LayoutBuilder(builder: (context, snapshot) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx < 0) {
            animateIcon();
            SimpleHiddenDrawerProvider.of(context).toggle();
          }
        },
        onTap: () {
          animateIcon();
          SimpleHiddenDrawerProvider.of(context).toggle();
        },
        child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.white,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(),
                    drawerNameCard(
                      size,
                      elevation: elevation,
                      user: user,
                      name: name,
                    ),
                    Spacer(),
                    imageBuilder(
                      imageUrl,
                      child: drawerProfileImageCard(size,
                          image: setImage(
                              imageUrl,
                              user == 'Student'
                                  ? ConstassetsString.student
                                  : ConstassetsString.developer),
                          elevation: elevation),
                      placeHolder: drawerProfileImageCard(size,
                          image: setImage(
                              null,
                              user == 'Student'
                                  ? ConstassetsString.student
                                  : ConstassetsString.developer),
                          elevation: elevation),
                    ),
                    Spacer(),
                    drawerProfileInfo(size,
                        children: infoChildren, elevation: elevation),
                    Spacer(),
                    Card(
                      elevation: elevation,
                      margin: EdgeInsets.all(0),
                      child: profileFlatButton(size,
                          radius: BorderRadius.horizontal(
                              right: Radius.circular(radius ?? 15)),
                          onPressed: () {
                        animateIcon();
                        SimpleHiddenDrawerProvider.of(context).toggle();
                        Navigator.of(context).pushNamed(profileRoute);
                      }, text: 'Edit Profile'),
                    ),
                    Spacer(),
                    Card(
                      shape: bordershape(15),
                      elevation: elevation ?? 5,
                      margin: EdgeInsets.all(0),
                      child: Container(
                        width: size.height / 3.86,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            profileFlatButton(size,
                                radius: BorderRadius.only(
                                    topRight: Radius.circular(radius ?? 15)),
                                onPressed: () {
                              animateIcon();
                              SimpleHiddenDrawerProvider.of(context).toggle();
                              Navigator.of(context).pushNamed(WelcomeScreen.id);
                              model.logoutUser();
                            }, text: "Logout"),
                            Divider(color: Colors.black, height: 3),
                            profileFlatButton(size, onPressed: () {
                              animateIcon();
                              SimpleHiddenDrawerProvider.of(context).toggle();
                              // Navigator.of(context).pushNamed(//TODO: Feedback route);
                            }, text: "Complaints & Feedback"),
                            Divider(color: Colors.black, height: 3),
                            profileFlatButton(size,
                                radius: BorderRadius.only(
                                    bottomRight: Radius.circular(radius ?? 15)),
                                onPressed: () {
                              animateIcon();

                              SimpleHiddenDrawerProvider.of(context).toggle();
                              // Navigator.of(context).pushNamed(//TODO: aboutRoute);
                            }, text: "About")
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ]),
            )),
      ),
    );
  });
}

FutureBuilder<Response> imageBuilder(url, {Widget child, Widget placeHolder}) {
  return FutureBuilder<Response>(
      future: get(url),
      builder: (context, snapshot) {
        if (snapshot != null && snapshot.data != null) {
          if (snapshot.data.statusCode == 200) {
            return child;
          } else {
            return placeHolder;
          }
        } else {
          return placeHolder;
        }
      });
}

FutureBuilder<Object> futurePageBuilder<Object>(
    Object object, Future<Object> future,
    {@required Widget Function(Object snapshotData) child}) {
  return FutureBuilder(
      future:
          object == null ? future : Future.delayed(Duration(milliseconds: 300)),
      builder: (context, snapshot) {
        if ((snapshot != null && snapshot.data != null) || object != null) {
          return child(snapshot.data ?? object);
        } else {
          return kBuzyPage();
        }
      });
}

BottomNavyBarItem bottomNavyBarItem({Icon icon, String text}) {
  return BottomNavyBarItem(
      activeColor: mainColor,
      textAlign: TextAlign.center,
      inactiveColor: black,
      icon: icon,
      title: Text(text));
}

ImageProvider<dynamic> setImage(String url, String defaultImage) {
  return url != "default" && url != null && url != ''
      ? NetworkImage(
          url,
        )
      : AssetImage(defaultImage);
}

/* ImageProvider<dynamic> setImage(String url, String defaultImage) {
  return url != "default"
      ? FadeInImage.assetNetwork(placeholder: defaultImage, image: url)
      : AssetImage(defaultImage);
} */
