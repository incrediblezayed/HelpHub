import 'package:helphub/imports.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = 'WelcomeScreen';
  List<PageViewModel> page(BuildContext context) {
    return [
      PageViewModel(
        pageColor: Color(0xff80DEEA),
        bubbleBackgroundColor: Color(0xff80DEEA),
        bubble: Center(
          child: Text('1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        title: Container(),
        body: Column(
          children: <Widget>[
            Text(
              ConstString.welcome1_heading,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                ConstString.welcome1,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        mainImage: Image.asset(
          ConstassetsString.welcome1,
          // fit: BoxFit.none,
          width: MediaQuery.of(context).size.width - 60,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle(color: Colors.white),
      ),
      PageViewModel(
        bubble: Center(
          child: Text('2',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        pageColor: Color(0xff2ab1e0), //Color(0xff80DEEA),
        bubbleBackgroundColor: Color(0xff2ab1e0),

        title: Container(),
        body: Column(
          children: <Widget>[
            Text(
              ConstString.welcome2_heading,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                ConstString.welcome2,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        mainImage: Image.asset(
          ConstassetsString.welcome2,
          // fit: BoxFit.none,
          width: MediaQuery.of(context).size.width - 100,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle(color: Colors.white),
      ),
      PageViewModel(
        bubbleBackgroundColor: Color(0xff008b88),
        bubble: Center(
          child: Text('3',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        pageColor: Color(0xff008b88),
        title: Container(),
        body: Column(
          children: <Widget>[
            Text(
              ConstString.welcome3_heading,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Text(
                ConstString.welcome3,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        mainImage: Image.asset(
          ConstassetsString.welcome3,
          // fit: BoxFit.none,
          width: MediaQuery.of(context).size.width - 60,
          alignment: Alignment.center,
        ),
        textStyle: TextStyle(color: Colors.white),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          IntroViewsFlutter(
            page(context),
            onTapDoneButton: () => kopenPage(context, Login()),
            fullTransition: 450,
            showNextButton: true,
            showBackButton: true,
            skipText: Text(
              '↠',
              style: TextStyle(
                // color: Colors.white,
                fontSize: 30,
              ),
            ),
            backText: Text(
              '←',
              style: TextStyle(
                //color: Colors.white,
                fontSize: 30,
              ),
            ),
            nextText: Text(
              '→',
              style: TextStyle(
                // color: Colors.blue,
                fontSize: 30,
              ),
            ),
            showSkipButton: true,
            doneText: Text("Done"),
            pageButtonsColor: Color.fromARGB(100, 254, 198, 27),
            pageButtonTextStyles: new TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          Positioned(
            bottom: 60.0,
            left: 50,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Hero(
                tag: 'title',
                transitionOnUserGestures: true,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width - 100,
                  onPressed: () => kopenPage(context, Login()),
                  color: Colors.white,
                  child: Text(
                    ConstString.get_started,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
