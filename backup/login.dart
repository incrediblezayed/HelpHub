/* import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:helphub/Developers/UI/DeveloperProfile.dart';
import 'package:helphub/Shared/ForgotPassword.dart';
import 'package:helphub/Students/UI/StudentProfile.dart';
import 'package:helphub/imports.dart';
import 'dart:ui' as ui;

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserType loginType = UserType.STUDENT;
  String notYetRegisteringText = ConstString.not_registered;
  bool isRegistered = false;
  ButtonType buttonType = ButtonType.LOGIN;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  loginRegisterBtnTap(LoginPageModel model, BuildContext context) async {
    if (emailController.text == null || passwordController.text == null) {
      _scaffoldKey.currentState
          .showSnackBar(ksnackBar(context, 'Please enter details properly'));
    } else {
      if (emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        _scaffoldKey.currentState
            .showSnackBar(ksnackBar(context, 'Please enter details properly'));
      } else {
        bool response = await model.checkUserDetails(
          email: emailController.text,
          password: passwordController.text,
          userType: loginType,
          buttonType: buttonType,
          confirmPassword: confirmPasswordController.text,
        );
        if (response) {
          if (locator<AuthenticationServices>().userType ==
              UserType.DEVELOPERS) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => DeveloperProfile()),
                (r) => false);
          } else if (locator<AuthenticationServices>().userType ==
              UserType.STUDENT) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => StudentProfile()),
                (r) => false);
          }
        } else {
          _scaffoldKey.currentState
              .showSnackBar(ksnackBar(context, 'something went wrong...'));
        }
        _scaffoldKey.currentState
            .showSnackBar(ksnackBar(context, model.currentLoggingStatus));
      }
    }
  }

  switchLogin(dynamic value) {
    setState(() {
      loginType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginPageModel>(
      onModelReady: (model) => model,
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: true,
          appBar: TopBar(
              title: // Text(
                  ConstString.login, //),
              child: kBackBtn,
              onPressed: () {
                Navigator.pop(context);
              }),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (model.state == ViewState.Idle)
                  await loginRegisterBtnTap(model, context);
              },
              label:
                  Text(buttonType == ButtonType.LOGIN ? 'Login' : 'Register')),
          body: Stack(
            children: <Widget>[
              Container(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      children: <Widget>[
                        Text("You are a?"),
                        CustomRadioButton(
                          buttonColor: Theme.of(context).canvasColor,
                          buttonLables: ['Student', 'Developer'],
                          buttonValues: [UserType.STUDENT, UserType.DEVELOPERS],
                          radioButtonValue: (value) {
                            switchLogin(value);
                          },
                          selectedColor: Theme.of(context).accentColor,
                        ),
                        loginType == UserType.STUDENT
                            ? TextField(
                                onChanged: (email) {},
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: ConstString.email_hint,
                                  labelText: ConstString.email,
                                ),
                                controller: emailController,
                              )
                            : TextField(
                                onChanged: (id) {},
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: ConstString.devId_hint,
                                  labelText: ConstString.devId,
                                ),
                                controller: emailController,
                              ),
                        TextField(
                          obscureText: true,
                          onChanged: (password) {},
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: ConstString.password_hint,
                            labelText: ConstString.password,
                          ),
                          controller: passwordController,
                        ),
                        loginType == UserType.STUDENT
                            ? isRegistered
                                ? TextField(
                                    obscureText: true,
                                    onChanged: (password) {},
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                    decoration: kTextFieldDecoration.copyWith(
                                      hintText: ConstString.password_hint,
                                      labelText: ConstString.confirm_password,
                                    ),
                                    controller: confirmPasswordController,
                                  )
                                : Container()
                            : Container(),
                        SizedBox(
                          height: 15,
                        ),
                        Hero(
                          tag: 'otpForget',
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                loginType == UserType.STUDENT
                                    ? ReusableRoundedButton(
                                        child: Text(
                                          notYetRegisteringText,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (buttonType ==
                                                ButtonType.LOGIN) {
                                              buttonType = ButtonType.REGISTER;
                                            } else {
                                              buttonType = ButtonType.LOGIN;
                                            }
                                            isRegistered = !isRegistered;
                                            notYetRegisteringText = isRegistered
                                                ? ConstString.regidtered
                                                : ConstString.not_registered;
                                          });
                                        },
                                        height: 40,
                                      )
                                    : Container(),
                                ReusableRoundedButton(
                                  child: Text(
                                    ConstString.need_help,
                                    style: TextStyle(
                                      // color: kmainColorTeacher,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {
                                    //Forget Password Logic
                                    kopenPage(context, ForgotPasswordPage());
                                  },
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              model.state == ViewState.Busy
                  ? Container(
                      // color: Colors.red,
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: kBuzyPage(color: Theme.of(context).primaryColor),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
 */