/* 
//enum userType { developer, students }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Help Hub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login());
  }
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String uid, email, password;
  userType type;
  void signup() async {
    CollectionReference ref = Firestore.instance
        .collection("users")
        .document('Login')
        .collection("developers");
    QuerySnapshot qs = await ref.getDocuments();
    if (type == userType.students) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } else {
      qs.documents.forEach((snap) async {
        if (snap.documentID == uid) {
          DocumentSnapshot snapshot = await ref.document(uid).get();
          FirebaseAuth.instance.signInWithEmailAndPassword(
              email: snapshot.data['email'], password: password);
        }
      });
    }
  }

  List<Widget> kuchbhi() {
    switch (type) {
      case userType.students:
        return [
          TextField(
            onChanged: (x) => email = x,
          ),
          TextField(
            onChanged: (x) => password = x,
          )
        ];
        break;
      case userType.developer:
        return [
          TextField(
            onChanged: (x) => uid = x,
            decoration: InputDecoration(labelText: "developer"),
          ),
          TextField(
            onChanged: (x) => password = x,
          ),
          FlatButton(onPressed: signup, child: Text("data"))
        ];
        break;
    }
    return [];
  }

  void d() {
    setState(() {
      type = userType.developer;
    });
  }

  void s() {
    setState(() {
      type = userType.students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    s();
                  },
                  child: Text("data")),
              FlatButton(
                  onPressed: () {
                    d();
                  },
                  child: Text("data")),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dis(),
                        ));
                  },
                  child: Text("hi")),
              Column(
                children: kuchbhi(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Dis extends StatefulWidget {
  Dis({Key key}) : super(key: key);

  @override
  _DisState createState() => _DisState();
}

class _DisState extends State<Dis> {
  
  
  Widget buildFoodItems() {
    CollectionReference collectionReference =
        Firestore.instance.collection('users').document('Profile').collection('Developers');
    Stream<QuerySnapshot> stream;
    stream = collectionReference.snapshots();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: new StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return new ListView(
                  children: snapshot.data.documents.map((document) {
                    return new FoodItemCard(
                      foodItem: Developer.fromMap(document.data),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: buildFoodItems()),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final Developer foodItem;
  FoodItemCard({Key key, this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            Image.network(foodItem.photoUrl),
            Text(foodItem.name),
            Text(foodItem.city),
            Text(foodItem.country),
            Text(foodItem.email)
          ],
        );
  }
}
 */


/*   Widget allProjects({Project project, bool enrolled}) {
    String completedyear = project.completion.toDate().year.toString();
    String completedmonth = project.completion.toDate().month.toString();
    String completeddate = project.completion.toDate().day.toString();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyProject(
                      project: project,
                      val: false,
                    )));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        child: Card(
          color: enrolled == true
              ? project.current == true ? Colors.blue : Colors.white
              : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Image(image: setImage(project.photo)),
              ),
              Spacer(
                flex: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(project.name),
                  Text(project.projectInfo['Language']),
                  Text(project.projectInfo['Database']),
                  enrolled == true
                      ? project.current == true
                          ? Text("In Progress")
                          : Text(
                              '$completeddate - $completedmonth - $completedyear')
                      : Text(
                          '$completeddate - $completedmonth - $completedyear')
                ],
              ),
              Spacer(
                flex: 5,
              ),
              Text(project.price)
            ],
          ),
        ),
      ),
    );
  } */