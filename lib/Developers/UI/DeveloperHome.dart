
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:helphub/imports.dart';

class DeveloperHome extends StatefulWidget {
  static const id = 'DeveloperHome';

  @override
  _DeveloperHomeState createState() => _DeveloperHomeState();
}

class _DeveloperHomeState extends State<DeveloperHome>
    with SingleTickerProviderStateMixin {
  SharedPreferencesHelper sharedPreferencesHelper =
      locator<SharedPreferencesHelper>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  PageController pageController;
  int selectedIndex = 0;
  DocumentReference currentProjectReference;
  DocumentSnapshot snapShot;

  AnimationController _animationController;
  bool open = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    pageController = PageController();
    registerNotification();
    configLocalNotification();
    super.initState();
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

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(microseconds: 150), curve: Curves.ease);
    });
    print(index);
  }

  void registerNotification() async {
    String currentUser = await sharedPreferencesHelper.getDevelopersId();

    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification'], true);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      showNotification(message['notification'], false);

      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      showNotification(message['notification'], false);
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document('Profile')
          .collection('Developers')
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
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelect);
  }

  void showNotification(message, bool foreground) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.h2.helphub' : 'com.h2.helphub',
      'Help Hub',
      'your channel description',
      playSound: true,
      enableVibration: true,
      autoCancel: true,
      channelShowBadge: true,
      enableLights: true,
      // style: message['tag'] == 'chat'
      //     ? AndroidNotificationStyle.Messaging
      //     : AndroidNotificationStyle.Default,
      groupKey: message['tag'],
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    if (foreground) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(message['body'])));
    } else {
      await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
          message['body'].toString(), platformChannelSpecifics,
          payload: json.encode(message));
    }
  }

  Future onSelect(message) {
    if (message['tag'] == 'chat') {
      enrolledstudents != null
          ? student = enrolledstudents
              .singleWhere((student) => student.displayName == message['title'])
          : student = null;
      student != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        peerId: student.email,
                        peerAvatar: student.photoUrl,
                        userType: UserType.DEVELOPERS,
                        student: student,
                      )))
          : setState(() {
              selectedIndex = 3;
            });
    } else {
      setState(() {
        selectedIndex = 1;
      });
    }
    return Future.delayed(Duration(seconds: 2));
  }

  Project project;
  Student student;
  List<Student> enrolledstudents;
  List<Student> requests;
  List<Project> allProject;

  int a = 0;
  @override
  Widget build(BuildContext context) {
    Developer developer = Provider.of<Developer>(context);
    var login = locator<LoginPageModel>();
    return BaseView<DeveloperHomeModel>(
        onModelReady: (model) => model.getAll(),
        builder: (context, model, child) {
          if (model.state == ViewState.Idle) {
            if (a == 0) {
              allProject = model.allProject;
              project = model.project;
              requests = model.requests;
              student = model.student;
              enrolledstudents = model.enrolledstudents;
              a++;
            }
          }
          if (allProject == null ||
              project == null ||
              requests == null ||
              student == null ||
              enrolledstudents == null) {
            allProject = model.allProject;
            project = model.project;
            requests = model.requests;
            student = model.student;
            enrolledstudents = model.enrolledstudents;
            a++;
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: SimpleHiddenDrawer(
              slidePercent: 53,
              enableCornerAnimin: true,
              isDraggable: true,
              verticalScalePercent: 99,
              menu: buildMenu(
                  user: 'Developer',
                  name: developer.displayName,
                  imageUrl: developer.photoUrl,
                  profileRoute: DeveloperProfile.id,
                  animateIcon: handleOnPressed,
                  elevation: 5,
                  radius: 15,
                  infoChildren: [
                    SizedBox(height: 7),
                    Text(developer.email ?? '', style: infoStyle()),
                    SizedBox(height: 7),
                    Text(developer.language ?? '', style: infoStyle()),
                    SizedBox(height: 7),
                    Text(developer.qualification ?? '', style: infoStyle()),
                    SizedBox(height: 7),
                    Text(developer.experience ?? '', style: infoStyle()),
                    SizedBox(height: 7),
                    Text(developer.city ?? '', style: infoStyle()),
                    SizedBox(height: 7),
                    Text(developer.country ?? '', style: infoStyle()),
                    SizedBox(height: 7),
                  ]),
              screenSelectedBuilder: (position, cont) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: TopBar(
                    onTitleTapped: () {
                      login.logoutUser();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => WelcomeScreen()));
                    },
                    title: title(),
                    child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _animationController,
                    ),
                    onPressed: () {
                      handleOnPressed();
                      cont.toggle();
                    },
                  ),
                  body: PageView(
                    pageSnapping: true,
                    physics: BouncingScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (index) => onItemTapped(index),
                    children: <Widget>[
                      FutureBuilder(
                          future: enrolledstudents == null
                              ? model.getenrolledStudents()
                              : Future.delayed(Duration(milliseconds: 300)),
                          builder: (context, snapshot) {
                            if (snapshot != null || enrolledstudents != null) {
                              return RefreshIndicator(
                                  onRefresh: () {
                                    return refresh(model);
                                  },
                                  child: buildEnrolled(developer,
                                      snapshot.data ?? enrolledstudents));
                            } else {
                              return progressIndicator();
                            }
                          }),
                      FutureBuilder<List<Student>>(
                          future: requests == null
                              ? model.getrequestList()
                              : Future.delayed(Duration(milliseconds: 300)),
                          builder: (context, snapshot) {
                            if (snapshot != null || requests != null) {
                              return RefreshIndicator(
                                  onRefresh: () {
                                    return refresh(model);
                                  },
                                  child: buildRequest(
                                      model, snapshot.data ?? requests));
                            } else {
                              return progressIndicator();
                            }
                          }),
                      RefreshIndicator(
                          onRefresh: () {
                            return refresh(model);
                          },
                          child: buildMyProject()),
                      FutureBuilder<List<Student>>(
                          future: enrolledstudents == null
                              ? model.getenrolledStudents()
                              : Future.delayed(Duration(milliseconds: 300)),
                          builder: (context, snapshot) {
                            if (snapshot != null || enrolledstudents != null) {
                              return RefreshIndicator(
                                onRefresh: () {
                                  return refresh(model);
                                },
                                child: buildChat(
                                    snapshot.data ?? enrolledstudents),
                              );
                            } else {
                              return progressIndicator();
                            }
                          }),
                      FutureBuilder<List<Project>>(
                          future: allProject == null
                              ? model.getAllProjects()
                              : Future.delayed(Duration(milliseconds: 300)),
                          builder: (context, snapshot) {
                            if (snapshot != null || allProject != null) {
                              return RefreshIndicator(
                                  onRefresh: () {
                                    return refresh(model);
                                  },
                                  child: buildAllProject(
                                      snapshot.data ?? allProject));
                            } else {
                              return progressIndicator();
                            }
                          })
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: BottomNavyBar(
                iconSize: 30,
                selectedIndex: selectedIndex,
                onItemSelected: (index) => onItemTapped(index),
                // },
                itemCornerRadius: 15,
                showElevation: false,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                animationDuration: Duration(milliseconds: 150),
                curve: Curves.bounceInOut,
                backgroundColor: Colors.white,
                items: [
                  BottomNavyBarItem(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.black,
                      textAlign: TextAlign.center,
                      icon: Icon(Icons.supervisor_account),
                      title: Text("Enrolled")),
                  BottomNavyBarItem(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.black,
                      textAlign: TextAlign.center,
                      icon: Icon(Icons.recent_actors),
                      title: Text("Requests")),
                  BottomNavyBarItem(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.black,
                      textAlign: TextAlign.center,
                      icon: Icon(Icons.personal_video),
                      title: Text("Current Project")),
                  BottomNavyBarItem(
                      inactiveColor: Colors.black,
                      activeColor: Colors.blue,
                      textAlign: TextAlign.center,
                      icon: Icon(CommunityMaterialIcons.chat_processing),
                      title: Text("Chats")),
                  BottomNavyBarItem(
                      inactiveColor: Colors.black,
                      activeColor: Colors.blue,
                      textAlign: TextAlign.center,
                      icon: Icon(Icons.pie_chart_outlined),
                      title: Text("All Projects")),
                ]),
          );
        });
  }

  Future<Null> refresh(DeveloperHomeModel model) async {
    await Future.delayed((Duration(milliseconds: 1200)));
    setState(() {
      model.getAll();
      a = 0;
    });
    return null;
  }

  String title() {
    switch (selectedIndex) {
      case 0:
        return "Home";
        break;
      case 1:
        return "Requests";
        break;
      case 2:
        return "Current Project";
        break;
      case 3:
        return "Chat";
        break;
      case 4:
        return 'All Projects';
        break;
      default:
        return "Home";
    }
  }

  Widget buildChat(List<Student> enrolledStudents) {
    if (enrolledStudents != null)
      return ListView.separated(
          separatorBuilder: (context, i) => Divider(color: Colors.black),
          itemCount: enrolledstudents.length,
          itemBuilder: (context, index) {
            return chatList(enrolledstudents[index]);
          });
    else
      return Center(
        child: Text("No chats"),
      );
  }

  Widget chatList(Student student) {
    return ListTile(
      isThreeLine: true,
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentDetail(
                  isARequest: false,
                  student: student,
                )));
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Chat(
                peerId: student.email,
                peerAvatar: student.photoUrl,
                student: student,
                userType: UserType.DEVELOPERS)));
      },
      leading: Hero(
        tag: '${student.displayName}+1',
        child: CircleAvatar(
          backgroundImage:
              setImage(student.photoUrl, ConstassetsString.student),
        ),
      ),
      title: Hero(
          transitionOnUserGestures: true,
          tag: student.email,
          child: Card(
            color: Colors.transparent,
            child: Text(student.displayName),
            elevation: 0,
          )),
      subtitle: Text(student.email),
      trailing: Hero(
        transitionOnUserGestures: true,
        tag: student.displayName,
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget buildAllProject(List<Project> projects) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            child: child,
            scale: animation,
          );
        },
        child: projects.length != 0
            ? ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return AllProjects(
                    userType: UserType.DEVELOPERS,
                    project: projects[index],
                  );
                })
            : Text("No Projects"));
  }

  Widget buildMyProject() {
    return MyProject(
      userType: UserType.DEVELOPERS,
      val: false,
      allProject: false,
    );
  }

  Widget buildRequest(DeveloperHomeModel model, List<Student> request) {
    if (request != null)
      return AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              child: child,
              scale: animation,
            );
          },
          child: request.length == 0
              ? Center(
                  child: Text("No requests"),
                )
              : ListView.builder(
                  itemCount: request.length,
                  itemBuilder: (context, index) {
                    return requestList(student: request[index], model: model);
                  },
                ));
    else
      return progressIndicator();
  }

  failed(String state) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Failed"),
            content: Text("Something went wrong, failed to $state the request"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  Widget requestList({Student student, DeveloperHomeModel model}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StudentDetail(
                isARequest: true,
                student: student,
              ))),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: setImage(
                            student.photoUrl, ConstassetsString.student))),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(student.displayName),
                  Text(student.email),
                ],
              ),
              Spacer(),
              IconButton(
                  icon: model.state2 == ViewState.Busy
                      ? SpinKitPulse(
                          color: Colors.blue,
                        )
                      : Icon(Icons.cancel),
                  onPressed: () async {
                    await rejectRequest(model, student).then((val) {
                      if (val) {
                        requests.remove(student);
                      } else {
                        failed('reject');
                      }
                    });
                  }),
              IconButton(
                  icon: model.state == ViewState.Busy
                      ? SpinKitPulse(
                          color: Colors.blue,
                        )
                      : Icon(Icons.done),
                  onPressed: () async {
                    await acceptRequest(model, student).then((val) {
                      if (val) {
                        requests.remove(student);
                      } else {
                        failed('accept');
                      }
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> acceptRequest(DeveloperHomeModel model, Student student) async {
    bool val = false;
    if (model.state == ViewState.Idle) {
      val = await model.acceptRequest(student);
    }
    return val;
  }

  Future<bool> rejectRequest(DeveloperHomeModel model, Student student) async {
    bool val = false;
    if (model.state == ViewState.Idle) {
      val = await model.rejectRequest(student);
    }
    return val;
  }

  Widget buildEnrolled(Developer developer, List<Student> student) {
    if (student == null) {
      return progressIndicator();
    } else {
      return student.length != 0
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: student.length,
              itemBuilder: (context, index) {
                return enrolledList(student: student[index]);
              },
            )
          : Center(
              child: Text("No Students Enrolled"),
            );
    }
  }

  Widget enrolledList({Student student}) {
    var media = MediaQuery.of(context);
    Orientation orientation = media.orientation;
    Size size = media.size;
    double height = size.height;
    double width = size.width;
    var name = student.displayName.split(' ');
    String firstName = name[0];

    String lastName = (name.length > 1) ? name[1] : " "; //Ali
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StudentDetail(
                  student: student,
                  isARequest: false,
                )));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 18.0),
        child: Container(
          alignment: Alignment.center,
          child: Hero(
            tag: '${student.displayName}',
            child: Material(
              elevation: 0.7,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  height: (orientation == Orientation.portrait)
                      ? height / 5.31
                      : 150,
                  width:
                      (orientation == Orientation.portrait) ? width - 50 : 350,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue, Colors.blue[900]])),
                        margin: EdgeInsets.only(top: 90),
                        height: (orientation == Orientation.portrait)
                            ? height / 10
                            : 70,
                        width: (orientation == Orientation.portrait)
                            ? width - 50
                            : 350,
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue[900],
                          radius: 70,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(student.photoUrl),
                            backgroundColor: Colors.blue,
                            radius: 68,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 150),
                        child: Text(
                          '$firstName'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue[900]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 43, left: 150),
                        child: Text(
                          '$lastName'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue[900]),
                        ),
                      ),
                      Container(
                        color: Colors.blue,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 67, left: 150),
                        child: Text(
                          '${student.qualification}'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue[50]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 95, left: 150),
                        child: Text(
                          '${student.email}',
                          style:
                              TextStyle(fontSize: 16, color: Colors.blue[50]),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 110, left: 200),
                        child: Text(
                          '${student.city}'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue[50]),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),

        // TODO: Old UI
        //child: Container(
        //   height: height / 4,
        //   child: Card(
        //     elevation: 3,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.max,
        //       children: <Widget>[
        //         Expanded(
        //             child: Hero(
        //           tag: '${student.displayName}+1',
        //           child: Container(
        //             decoration: BoxDecoration(
        //               image: DecorationImage(
        //                 image: setImage(
        //                     student.photoUrl, ConstassetsString.student),
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //         )),
        //         Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: <Widget>[
        //               Text(student.displayName),
        //               Text(student.qualification)
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
