
import 'package:get/get.dart';
import 'package:helphub/Shared/Pages/About.dart';

import 'Students/UI/StudentHome.dart';
import 'imports.dart';

void main() {
  timeDilation = 2;
  Provider.debugCheckInvalidValueType = null;
  setupLocator();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Developer>.value(
            initialData: Developer(),
            value: locator<DeveloperProfileServices>()
                .loggedInDeveloperStream
                .stream),
        StreamProvider<Student>.value(
            initialData: Student(),
            value:
                locator<StudentProfileServices>().loggedInStudentStream.stream),
        StreamProvider<FirebaseUser>.value(
          initialData: null,
          value: locator<AuthenticationServices>().fireBaseUserStream.stream,
        ),
        StreamProvider<UserType>.value(
          initialData: UserType.UNKNOWN,
          value: locator<AuthenticationServices>().userTypeStream.stream,
        ),
        StreamProvider<bool>.value(
          initialData: false,
          value: locator<AuthenticationServices>().isUserLoggedInStream.stream,
        ),
      ],
      child: HelpHub(),
    );
  }
}

class HelpHub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: mainColor,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder()
          })),
      title: 'Help Hub',
      routes: {
        StudentPage.id: (context) => StudentPage(),
        DeveloperHome.id: (context) => DeveloperHome(),
        StudentProfile.id: (context) => StudentProfile(),
        DeveloperProfile.id: (context) => DeveloperProfile(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        AboutPage.id: (context) => AboutPage()
      },
      home: getHome(context),
    );
  }

  Widget getHome(BuildContext context) {
    Developer currentDeveloper = Provider.of<Developer>(context, listen: false);
    Student currentStudent = Provider.of<Student>(context, listen: false);
    UserType userType = Provider.of<UserType>(context, listen: false);
    bool isUserLoggedIn = Provider.of<bool>(context);
    if (Provider.of<FirebaseUser>(context) == null) {
      return WelcomeScreen();
    }

    if (userType == UserType.UNKNOWN) {
      return WelcomeScreen();
    }

    if (isUserLoggedIn) {
      if (userType == UserType.STUDENT) {
        return currentStudent != null ?
                currentStudent.displayName == null ||
                currentStudent.displayName == ""
            ? StudentProfile()
            : StudentPage() : StudentProfile();
      }
      if (userType == UserType.DEVELOPERS) {
        return currentDeveloper != null ?
                currentDeveloper.displayName == null ||
                currentDeveloper.displayName == ""
            ? DeveloperProfile()
            : DeveloperHome() : DeveloperProfile();
      }
    } else {
      return WelcomeScreen();
    }
    return WelcomeScreen();
  }
}
