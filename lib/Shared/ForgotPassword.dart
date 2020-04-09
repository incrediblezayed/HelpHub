import 'package:flutter/material.dart';
import 'package:helphub/UI/Utility/constants.dart';
import 'package:helphub/UI/Widgets/TopBar.dart';
import 'package:helphub/UI/Utility/Resources.dart';
import 'package:helphub/imports.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

 // AuthenticationServices _authService = locator<AuthenticationServices>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: TopBar(
        child: kBackBtn,
        onPressed: () {
          kbackBtn(context);
        },
        title:// Text(
          ConstString.forgot_password,//),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            bottom: 25.0, left: 25.0, right: 25.0, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
              ),
              child: Text(
                ConstString.enter_registered_email,
                // textAlign: TextAlign.center,
               
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _emailController,
              // obscureText: true,
              onChanged: (email) {},
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              decoration: kTextFieldDecoration.copyWith(
                hintText: ConstString.email_hint,
                labelText: ConstString.email,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  /* ReusableRoundedButton(
                    elevation: 5,
                    child: Text(
                      ConstString.send_recovery_mail,
                      style: TextStyle(
                        // color: kmainColorTeacher,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () async {
                      //Sent Password reset link logic
                      if (_emailController.text.trim().contains('@') &&
                          _emailController.text.trim().contains('.')) {
                        AuthErrors authError = await _authService.passwordReset(
                            _emailController.text.trim().toString());
                        scaffoldKey.currentState.showSnackBar(
                          ksnackBar(
                            context,
                            AuthErrorsHelper.getValue(authError),
                          ),
                        );
                        ksnackBar(
                          context,
                          AuthErrorsHelper.getValue(authError),
                        );
                      } else {
                        ksnackBar(context, 'Email is Not Valid');
                      }
                    },
                    height: 50,
                  ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
