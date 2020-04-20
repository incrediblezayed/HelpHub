import 'package:helphub/imports.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  static String id = "AboutPage";
  const AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appName = "app";
  String appVersion;
  String buildNumber;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((packageInfo) {
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: TopBar(
        titleTag: "title",
        child: kBackBtn,
        title: "About",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                appName,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 35,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 10),
              Text(
                "Version $appVersion",
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                "Build Number $buildNumber",
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Created By: ",
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: "Hassan Ansari & Hassan Momin")
                ]),
              ),
              Text(data)
            ],
          ),
        ),
      ),
    ));
  }
}
