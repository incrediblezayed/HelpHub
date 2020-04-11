import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:helphub/Students/UI/DeveloperDetail.dart';
import 'package:helphub/imports.dart';

import 'DevelopersCard.dart';

class StudentPage extends StatefulWidget {
  static String id = 'student';
  StudentPage({Key key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with SingleTickerProviderStateMixin {
  SwiperController _swiperController;
  PageController pageController;

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  SharedPreferencesHelper sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();

  AnimationController _animationController;
  bool open = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    super.initState();

    registerNotification();
    configLocalNotification();
    _swiperController = SwiperController();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void handleOnPressed() {
    setState(() {
      open = !open;
      open ? _animationController.forward() : _animationController.reverse();
    });
  }

  void registerNotification() async {
    String currentUser = await sharedPreferencesHelper.getStudentsEmail();

    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document('Profile')
          .collection('Students')
          .document(currentUser)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.h2.helphub' : 'com.h2.helphub',
      'Help Hub',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(_selectedIndex,
          duration: Duration(microseconds: 150), curve: Curves.ease);
    });
  }

  int a = 0;

  Future<Null> refresh(StudentHomeModel model) async {
    await Future.delayed((Duration(milliseconds: 1200)));
    setState(() {
      model.getAll();
      //model.checkEnrolled();
      a = 0;
    });
    return null;
  }

  String buildenrolledtitle() {
    switch (_selectedIndex) {
      case 0:
        return "Developer";
        break;
      case 1:
        return "My Current Project";
        break;
      case 2:
        return "Chat";
        break;
      case 3:
        return "All Projects";
        break;
      default:
        return "Home";
    }
  }

  String buildtitle() {
    switch (_selectedIndex) {
      case 0:
        return "Explore";
        break;
      case 1:
        return "All Projects";
        break;
      default:
        return "Home";
    }
  }

  List<Developer> developers;
  List<Project> projects;
  Developer developer;
  Student student;
  Project project;
  @override
  Widget build(BuildContext context) {
    return BaseView<StudentHomeModel>(
      onModelReady: (model) => model.getStudentProfile(),
      builder: (context, model, child) {
        if (student == null ||
            developer == null ||
            developers == null ||
            projects == null) {
          if (model.state3 == ViewState.Idle) {
            model.getStudentProfile();
            student = model.student;
            model.getEnrolledDeveloperProfile();
            developer = model.enrolleddeveloper;
            model.getDevelopers();
            developers = model.developers;
            model.getProjects();
            projects = model.projects;
            model.getStudentProject();
            project = model.project;
            a++;
          }
        }
        if (model.state == ViewState.Idle) {
          if (a == 0) {
            model.getStudentProfile();
            student = model.student;
            model.getEnrolledDeveloperProfile();
            developer = model.enrolleddeveloper;
            model.getProjects();
            projects = model.projects;
            model.getDevelopers();
            developers = model.developers;
            model.getStudentProject();
            project = model.project;
            a++;
          }
        }
        return Scaffold(
            backgroundColor: Colors.white,
            body: FutureBuilder<Student>(
                future: student == null
                    ? model.getStudentProfile()
                    : Future.delayed(Duration(milliseconds: 300)),
                builder: (context, studentsnapshot) {
                  if (studentsnapshot.data != null || student != null) {
                    return SimpleHiddenDrawer(
                        slidePercent: 53,
                        enableCornerAnimin: true,
                        isDraggable: true,
                        verticalScalePercent: 99,
                        menu: buildMenu(
                          context,
                            elevation: 5,
                            radius: 15,
                            user: 'Student',
                            name: student.displayName ??
                                studentsnapshot.data.displayName,
                            imageUrl: student.photoUrl,
                            profileRoute: StudentProfile.id,
                            animateIcon: handleOnPressed,
                            infoChildren: [
                              SizedBox(height: 7),
                              Text(student.email ?? '', style: infoStyle()),
                              SizedBox(height: 7),
                              Text(student.qualification ?? '',
                                  style: infoStyle()),
                              SizedBox(height: 7),
                              Text(student.yearofcompletion ?? '',
                                  style: infoStyle()),
                              SizedBox(height: 7),
                              Text(student.city ?? '', style: infoStyle()),
                              SizedBox(height: 7),
                              Text(student.country ?? '', style: infoStyle()),
                              SizedBox(height: 7),
                            ]),
                        screenSelectedBuilder: (position, bloc) {
                          return Scaffold(
                              appBar: TopBar(
                                  rightButton: IconButton(
                                      icon: Icon(Icons.refresh),
                                      onPressed: () {
                                        refresh(model);
                                      }),
                                  title: student.enrolled == true
                                      ? buildenrolledtitle()
                                      : buildtitle(),
                                  child: AnimatedIcon(
                                      icon: AnimatedIcons.menu_close,
                                      progress: _animationController),
                                  onPressed: () {
                                    handleOnPressed();
                                    bloc.toggle();
                                  }),
                              body: student.enrolled == true
                                  ? FutureBuilder<Developer>(
                                      future: developer == null
                                          ? model.getEnrolledDeveloperProfile()
                                          : Future.delayed(
                                              Duration(milliseconds: 300)),
                                      builder: (context, developersnapshot) {
                                        if (developersnapshot.data != null ||
                                            developer != null) {
                                          return PageView(
                                              physics: BouncingScrollPhysics(),
                                              controller: pageController,
                                              onPageChanged: (index) {
                                                _onItemTapped(index);
                                              },
                                              children: enrolledbody(
                                                  studentsnapshot.data ??
                                                      student,
                                                  developersnapshot.data ??
                                                      developer,
                                                  model,
                                                  project,
                                                  projects));
                                        } else {
                                          return kBuzyPage();
                                        }
                                      })
                                  : FutureBuilder<List<Developer>>(
                                      future: developers == null
                                          ? model.getDevelopers()
                                          : Future.delayed(
                                              Duration(milliseconds: 300)),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null ||
                                            developers != null) {
                                          return PageView(
                                            physics: BouncingScrollPhysics(),
                                            controller: pageController,
                                            onPageChanged: (index) {
                                              _onItemTapped(index);
                                            },
                                            children: notEnrolledbody(
                                                student ?? studentsnapshot.data,
                                                model,
                                                snapshot.data ?? developers,
                                                projects),
                                          );
                                        } else {
                                          return kBuzyPage();
                                        }
                                      }));
                        });
                  } else {
                    return kBuzyPage();
                  }
                }),
            bottomNavigationBar: student != null
                ? BottomNavyBar(
                    itemCornerRadius: 15,
                    showElevation: false,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    animationDuration: Duration(milliseconds: 150),
                    curve: Curves.bounceInOut,
                    selectedIndex: _selectedIndex,
                    items: student.enrolled == false ? notEnrolled : enrolled,
                    onItemSelected: (index) => _onItemTapped(index))
                : null);
      },
    );
  }

  Widget buildMyProjects(Project project) {
    return MyProject(
      userType: UserType.STUDENT,
      val: false,
      allProject: false,
      project: project,
    );
  }

  Widget buildAllProjects(bool isEnrolled, List<Project> projects) {
    return projects != null
        ? projects.length == 0
            ? Center(
                child: Text("No Projects"),
              )
            : ListView.builder(
                itemCount: projects.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return AllProjects(
                      userType: UserType.STUDENT,
                      project: projects[index],
                      enrolled: isEnrolled);
                })
        : kBuzyPage();
  }

  Widget buildChat(Developer developer) {
    return Chat(
      peerId: developer.id,
      peerAvatar: developer.photoUrl,
      userType: UserType.STUDENT,
      developer: developer,
    );
  }

  Widget buildDeveloperProfile(Developer developer) {
    if (developer.displayName != 'N.A') {
      return DeveloperDetail(
        card: false,
        developer: developer,
      );
    } else {
      return Center(
        child: Text("Something went wrong"),
      );
    }
  }

  List<Widget> notEnrolledbody(Student student, StudentHomeModel model,
      List<Developer> developers, List<Project> projects) {
    return [
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 10),
              child: Text(
                "Hello, ${student.displayName}",
                style: TextStyle(fontSize: 28),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 10,
              ),
              child: Text(
                  '''Looks like you're not enrolled yet, choose any developer 
from below and get to work''',
                  style: TextStyle(fontSize: 17)),
            ),
            Spacer(),
            developers != null
                ? Container(
                    height: MediaQuery.of(context).size.height / 1.65,
                    child: Swiper(
                      viewportFraction: 1,
                      controller: _swiperController,
                      loop: false,
                      itemCount: developers.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width /
                                  10 /* , right: 30 */),
                          child: DevelopersCard(
                            student: student,
                            developer: developers[index],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text("Something went wrong"),
                  )
          ],
        ),
      ),
      buildAllProjects(false, projects),
    ];
  }

  List<Widget> enrolledbody(Student student, Developer developer,
      StudentHomeModel model, Project project, List<Project> projects) {
    return [
      buildDeveloperProfile(developer),
      buildMyProjects(project),
      buildChat(developer),
      buildAllProjects(true, projects),
    ];
  }

  List<BottomNavyBarItem> notEnrolled = [
    BottomNavyBarItem(
        activeColor: Colors.blue,
        icon: Icon(Icons.person_outline),
        title: Text('Explore Developers')),
    BottomNavyBarItem(
        activeColor: Colors.blue,
        icon: Icon(Icons.personal_video),
        title: Text('Projects')),
  ];

  List<BottomNavyBarItem> enrolled = [
    BottomNavyBarItem(
        activeColor: Colors.blue,
        icon: Icon(Icons.person_outline),
        title: Text('Developer')),
    BottomNavyBarItem(
        activeColor: Colors.blue,
        icon: Icon(Icons.personal_video),
        title: Text('My Project')),
    BottomNavyBarItem(
        activeColor: Colors.blue, icon: Icon(Icons.chat), title: Text('Chat')),
    BottomNavyBarItem(
        activeColor: Colors.blue,
        icon: Icon(Icons.pie_chart_outlined),
        title: Text('All Projects'))
  ];
}
