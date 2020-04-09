/* import 'package:helphub/imports.dart';
import 'package:helphub/model/projectmodel.dart';
import 'dart:math' as math;

class ProjectsPage extends StatefulWidget {
  final Project project;
  final Student student;
  ProjectsPage({
    Key key,
    @required this.project,
    @required this.student
  }) : super(key: key);

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  DocumentReference projectreference;
  Project get project => widget.project;
  Student get student => widget.student;

  SliverPersistentHeader makePinnedheader(String headerText, String price) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 160.0,
        child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Spacer(),
                Text(
                  headerText,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Spacer(
                  flex: 3,
                ),
                Row(children: [
                  Spacer(),
                  Text("Price",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Spacer(
                    flex: 3,
                  ),
                  Text(price,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                ]),
                Spacer(),
              ],
            )),
      ),
    );
  }

  ImageProvider<dynamic> setImage(Project project) {
    return project.photo != "default"
        ? NetworkImage(
            project.photo,
          )
        : AssetImage(ConstassetsString.student_welcome);
  }

  ImageProvider<dynamic> setStudentImage(String photo) {
    return photo != "default"
        ? NetworkImage(
            photo,
          )
        : AssetImage(ConstassetsString.student_welcome);
  }

  int selected = 0;
  changeRadioValue(index) {
    setState(() {
      selected = index;
    });
  }

  Widget studentList(
      {BuildContext context, Student student, int index, Developer developer}) {
    return ListTile(
      title: Text(student.displayName),
      subtitle: Text(student.email),
      leading: Image(image: setStudentImage(student.photoUrl)),
      onTap: () {
        showStudentDetailSheet(context, student, developer, true);
      },
    );
  }

  acceptProject() async {
    await projectreference.updateData({'current': true, 'rejected': false});
  }

  rejectProject() async {
    await projectreference.updateData({'rejected': true, 'view': false});
  }

  selectStudent(DocumentReference reference) async {
    project.requested = false;
    return await reference
        .collection('Projects')
        .document(project.name)
        .setData(project.toMap(project))
        .then((value) async {
      await projectreference.updateData(project.setRef(project));
    });
  }

  showStudentDetailSheet(
      BuildContext context, Student student, Developer developer, bool value) {
    DocumentReference reference = Firestore.instance
        .collection('users')
        .document('Profile')
        .collection('Students')
        .document(student.email);
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => Container(
              margin: EdgeInsets.only(top: 15),
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    student.displayName,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        fit: BoxFit.cover,
                        image: setStudentImage(student.photoUrl),
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text(student.displayName)
                    ],
                  ),
                ),
                bottomNavigationBar: value == true
                    ? BottomAppBar(child: RaisedButton(onPressed: () async {
                        project.studentProfile = reference;
                        selectStudent(reference);
                      }))
                    : Container(
                        height: 2,
                      ),
              ),
            ));
  }

  showAddStudentSheet(BuildContext context, Developer developer) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document('Enrolled')
                        .collection(developer.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.data.documents.length == 0) {
                        return Center(
                          child: Text("You don't have any students enrolled"),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return studentList(
                                context: context,
                                student: Student.fromSnapshot(
                                    snapshot.data.documents[index]),
                                developer: developer);
                          },
                        );
                      }
                    }),
        ),
            );
  }


  TextStyle titleStyle() {
    return TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
  }

  TextStyle valueStyle() {
    return TextStyle(
        fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300);
  }

  @override
  Widget build(BuildContext context) {
    Developer developer = Provider.of<Developer>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: <
            Widget>[
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: setImage(project))),
                )
              ],
            ),
          ),
          makePinnedheader(project.name, project.price),
          SliverFixedExtentList(
              itemExtent: 250,
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.only(left: 35, right: 100),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Project Information",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Project Type:",
                                        style: titleStyle(),
                                      ),
                                      SizedBox(height: 5),
                                      Text("Database:", style: titleStyle()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Language:", style: titleStyle()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("Framework:", style: titleStyle()),
                                      SizedBox(height: 5),
                                      Text("Authentication:",
                                          style: titleStyle())
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        project.projectInfo['Type'],
                                        style: valueStyle(),
                                      ),
                                      SizedBox(height: 5),
                                      Text(project.projectInfo['Database'],
                                          style: valueStyle()),
                                      SizedBox(height: 5),
                                      Text(project.projectInfo['Language'],
                                          style: valueStyle()),
                                      SizedBox(height: 5),
                                      Text(project.projectInfo['Framework'],
                                          style: valueStyle()),
                                      SizedBox(height: 5),
                                      Text(
                                          project.projectInfo['Authentication'],
                                          style: valueStyle()),
                                    ],
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      // Divider(color: Colors.black),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 45, right: 45),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Project Type:"),
                              SizedBox(height: 5),
                              Text("Database:"),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Language:"),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Framework:"),
                              SizedBox(height: 5),
                              Text("Authentication:")
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(project.projectInfo['Type']),
                              SizedBox(height: 5),
                              Text(project.projectInfo['Database']),
                              SizedBox(height: 5),
                              Text(project.projectInfo['Language']),
                              SizedBox(height: 5),
                              Text(project.projectInfo['Framework']),
                              SizedBox(height: 5),
                              Text(project.projectInfo['Authentication']),
                            ],
                          ),
                        ])),
              ]))
        ]),
        bottomNavigationBar: BottomAppBar(
          child: buildBottomWidget(context, developer),
        ),
      ),
    );
  }

  Widget buildBottomWidget(BuildContext context, Developer developer) {
    if (project.current) {
      if (student == null) {
        return Center(child: CircularProgressIndicator());
      } else if (student.displayName == "") {
        return FlatButton(
            onPressed: () {
              showAddStudentSheet(context, developer);
            },
            child: Text("Select a Student"));
      } else {
        return FlatButton(
            onPressed: () {
              showStudentDetailSheet(context, student, developer, false);
            },
            child: Text(student.displayName));
      }
    } else if (!project.rejected) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FlatButton(
                color: Colors.red,
                colorBrightness: Brightness.dark,
                onPressed: () {
                  rejectProject();
                },
                child: Text("Reject")),
          ),
          Expanded(
            child: FlatButton(
                color: Colors.green,
                colorBrightness: Brightness.dark,
                onPressed: () {
                  acceptProject();
                },
                child: Text("Accept")),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
 */