import 'dart:ui';
import 'package:BloodLine/services/auth.dart';
import 'package:BloodLine/services/database.dart';
import 'package:BloodLine/services/local_notifications.dart';
import 'package:BloodLine/services/notifications.dart';
import 'package:BloodLine/widgets/customDialog.dart';
import 'package:BloodLine/widgets/customInput.dart';
import 'package:BloodLine/widgets/outlineButton.dart' as outlineButton;
import 'package:BloodLine/widgets/customListTile.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:BloodLine/screens/authenticate/authenticate.dart';
import '../../test.dart';
import '../maps.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
    super.initState();

    LocalNotifications().initializing();

    //? Request permissions for iOS and web
    firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings()
    );
    //? Used for foreground messages
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print("on Message");
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
        );
        _scaffoldKey.currentState.showSnackBar(snackbar);
      },
      onBackgroundMessage: _onBackgroundMessage
    );



    //! Deletes all expired posts from the database
    DatabaseService().removeExpiredPosts();
  }

  int _pageState = 0; // decides if it is a welcome, login or register
  double windowWidth = 0; // the width of the screen
  double windowHeight = 0; // the height of the screen

  double _postsHeight = 0;
  double _postsWidth = 0;
  double _postsXOffset = 0; // the offset of the login page to the top side
  double _postsYOffset = 0;// the offset of the login page to the left side
  double _postsOpacity = 1;
  Radius _postsBottomLeft = Radius.circular(0);
  Radius _postsBottomRight = Radius.circular(0);

  double _createPostHeight = 0;
  double _createPostWidth = 0;
  double _createPostXOffset = 0;
  double _createPostYOffset = 0;

  // Fields that change dynamically when a Post button is pressed
  String _postBloodType = '';
  String _postDescription = '';
  String _postExpirationDate = '';
  String _postHospital = '';
  String _postAuthor = '';
  String _postCity = '';
  String _postDate = '';
  String _postPeopleJoined = '0';
  String _postAuthorDeviceToken = '';


  TextEditingController hospitalController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  DateTime _dateTime;
  String expirationDateText = 'Expiration date';

  //? Stores the key of the main scaffold of the main page,
  //? Used to display snackbars
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    switch(_pageState){

      case 0: //? The posts menu
        //? Rules for the main page that contains the posts
        _postsHeight = windowHeight - windowHeight/5;
        _postsWidth = windowWidth;
        _postsXOffset = 0;
        _postsYOffset = windowHeight/5;

        _postsOpacity = 1;
        _postsBottomLeft = Radius.circular(0);
        _postsBottomRight = Radius.circular(0);

        //? Rules for the Create Post Page
        _createPostHeight = 0;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight;

        break;
      case 1: //? Create Post

        //? Sets the Main Page back in place
        _postsHeight = windowHeight - windowHeight/5;
        _postsWidth = windowWidth;
        _postsXOffset = 0;
        _postsYOffset = windowHeight/5;
        _postsOpacity = 1;
        _postsBottomLeft = Radius.circular(0);
        _postsBottomRight = Radius.circular(0);

        //? Opens the Create Post page
        _createPostHeight = windowHeight - windowHeight/5.5;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight/5.5;
        break;
      case 2: //? Menu
        //? How will the Main page be displayed
        //? Sets the Main Page to the left side and squeezes it
        _postsHeight = windowHeight/1.2 ;
        _postsWidth = windowWidth;
        _postsXOffset = -windowWidth/2;
        _postsYOffset = windowHeight/10;
        _postsOpacity = 0.7;
        _postsBottomLeft = Radius.circular(25);
        _postsBottomRight = Radius.circular(25);

        //? Hides the Create Post page
        _createPostHeight = 0;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight;
        break;
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

          //! Side Menu
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.red[800],
            //! The white space where posts lay
            body: Column(
              children: [
                //! Empty space
                Expanded(child: Text(''), flex: 10,),
                //! Menu button
                Expanded(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                if(_pageState != 2)
                                  _pageState = 2;
                                else
                                  _pageState = 0;
                              });
                            },
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                            )
                        ),
                      )
                    ],
                  ),
                ),
                //! Empty space
                Expanded(
                  flex: 30,
                  child: Text('')
                ),
                //! The menu options
                Expanded(
                  flex: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //! used to space out the column of buttons to be on the
                      //! center of the open space
                      Container(
                        width: windowWidth/2,
                      ),
                      Column(
                        children: [
                          //! Add a post button
                          outlineButton.OutlineButton(
                            text: "Add post",
                            color: Colors.red[800],
                            borderColor: Colors.red[800],
                            textColor: Colors.white,
                            onPressed: (){
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              setState(() {
                                _pageState = 1;
                              });
                            },
                          ),
                          // Centers Map
                          outlineButton.OutlineButton(
                            text: "Centers",
                            color: Colors.red[800],
                            borderColor: Colors.red[800],
                            textColor: Colors.white,
                            onPressed: (){
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => Maps())
                              );
                            },
                          ),
                          //! Logout button
                          outlineButton.OutlineButton(
                            text: "Logout",
                            color: Colors.red[800],
                            borderColor: Colors.red[800],
                            textColor: Colors.white,
                            onPressed: (){
                              setState(() {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                AuthService(FirebaseAuth.instance).signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic>route) => false);

                              });
                            },
                          ),
                          outlineButton.OutlineButton(
                            text: "Test",
                            color: Colors.red[800],
                            borderColor: Colors.red[800],
                            textColor: Colors.white,
                            onPressed: (){
                              setState(() {
                                // ensures the keyboard is closed such that it doesn't open randomly
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Testpage()));
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                //! Empty space
                Expanded(child: Text(''), flex: 60,),
              ],
            )
          ),

          //! The posts page
          Stack(
            children: [
                //! Gets all the information from database
                //! and creates a listview filled with cards
                AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(
                        milliseconds: 700
                    ),
                    transform: Matrix4.translationValues(_postsXOffset, _postsYOffset, 1),
                    width: _postsWidth,
                    height: _postsHeight,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(_postsOpacity),

                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: _postsBottomLeft,
                            bottomRight: _postsBottomRight
                        )
                    ),
                    //! The list of posts from the database

                    //! Blurs the post page when a Post description is opened
                    child: StreamBuilder<QuerySnapshot>(
                      //! creates the connection to the posts branch
                      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData || snapshot.data.docs.length == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apartment_sharp,
                                size: windowWidth/10,
                                color: Colors.grey,
                              ),
                              Text('There are no calls yet!')
                            ],
                          );
                        }
                        //! if there are posts in the database
                        //! create a ListView that is filled with Cards
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index){
                              //! doc is the individual Post from the database
                              final doc = snapshot.data.docs[index];
                              return OpenContainer(
                                transitionDuration: Duration(milliseconds: 500),
                                //
                                //! The card view seen in the list builder
                                //
                                closedBuilder: (context, showDetails) {
                                  return Card(
                                      child: CustomListTile(
                                        height: windowHeight * 0.1,
                                        color: Colors.white,
                                        profileImage: doc['user-image']==null?
                                            Container(
                                              width: 70,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  color: Colors.blueAccent
                                                  )
                                            ) :
                                            Image.network(doc['user-image']),

                                        name: doc['name'],
                                        bloodType: doc['bloodtype'],
                                        city: doc['hospital'],
                                        date: doc['date'],
                                        onTap: () {
                                          //? Set the opening screen with the custom information about the related post
                                          // _postAuthor = doc['name'];
                                          // _postHospital = doc['hospital'];
                                          // _postBloodType = doc['bloodtype'];
                                          // _postDate = doc['date'];
                                          // _postDescription = doc['description'];
                                          // _postExpirationDate = doc['expiration-date'];
                                          // _postAuthorDeviceToken = doc['device-token'];
                                          //_postPeopleJoined = doc['people-joined'];
                                        },
                                      )
                                  );
                                },
                                ////////////////////////////
                                //! The open view with post description
                                ///////////////////////////
                                openBuilder: (context, showCard){
                                  //? Set the opening screen with the custom information about the related post
                                  _postAuthor = doc['name'];
                                  _postHospital = doc['hospital'];
                                  _postBloodType = doc['bloodtype'];
                                  _postDate = doc['date'];
                                  _postDescription = doc['description'];
                                  _postExpirationDate = doc['expiration-date'];
                                  _postAuthorDeviceToken = doc['device-token'];
                                  FirebaseFirestore.instance.collection('posts').doc(doc.id).collection('people-joined').get().then(
                                            (QuerySnapshot snapshot) => {_postPeopleJoined =  snapshot.docs.length.toString()}
                                            );

                                  return Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        //! Profile picture with Author name
                                        Expanded(
                                          flex: 25,
                                          child: Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.only(top: windowHeight/25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                doc['user-image']==null?
                                                  Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blueAccent,
                                                      )
                                                  ) :
                                                  SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: Image.network(doc['user-image'])),
                                                Text(_postAuthor)
                                              ],
                                            ),
                                          ),
                                        ),
                                        //! Post details with description
                                        Expanded(
                                          flex: 75,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20) ),
                                                border: Border.all(width: 2, color: Colors.grey[200]),
                                                color: Color(0xffF0F1FF)
                                            ),
                                            child: Column(
                                              children: [
                                                //! Top space
                                                Expanded(flex: 3, child: Text('')),
                                                //! Bloodtype
                                                //! Hospital
                                                //! City
                                                //! Expiration
                                                //! It has a Row with 2 Columns, one with the type of information and one with user info
                                                Expanded(
                                                  flex: 27,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      //! Info types
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text('Blood type'),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Flexible(child: Text('Hospital',overflow: TextOverflow.ellipsis,)),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text('City'),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text('Joined'),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text('Expiration'),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                      //! User info
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(_postBloodType),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Flexible(
                                                                  child: Text(
                                                                    _postHospital,
                                                                  )
                                                              ),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(_postCity),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(_postPeopleJoined),
                                                                ],
                                                              )),
                                                          Container(
                                                              width: windowWidth/5,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(_postExpirationDate),
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                //! Space between details and description
                                                Expanded(flex: 3, child: Text('')),
                                                //! Description
                                                Expanded(
                                                  flex: 67,
                                                  child: Container(
                                                    //! 90% of window width
                                                    width: windowWidth - windowWidth/10,
                                                    padding: EdgeInsets.all(windowWidth/40),
                                                    child: SingleChildScrollView(
                                                        scrollDirection: Axis.vertical,
                                                        child: Text(_postDescription)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),
                                                ),
                                                //! Space between description and buttons
                                                Expanded(flex: 5, child: Text('')),
                                                //! Buttons
                                                Expanded(
                                                    flex: 10,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        //! Back button
                                                        outlineButton.OutlineButton(
                                                          onPressed: (){
                                                            setState(() {
                                                              showCard();
                                                            });
                                                          },
                                                          width: windowWidth/4,
                                                          height: windowHeight/20,
                                                          text: 'Back',
                                                          color: Color(0xffF0F1FF),
                                                          textColor: Colors.black,
                                                          borderColor: Color(0xFF9dd9d2),
                                                        ),
                                                        //! Join button
                                                        outlineButton.OutlineButton(
                                                          onPressed: () async {
                                                            User user = FirebaseAuth.instance.currentUser;
                                                            // If the user tries to join his own post, a snackbar will appear with a warning
                                                            // Else if the user is already joined in a post, a snackbar will appear with a warning
                                                            if(user.uid == doc['user-id']) {
                                                              // Close the post description
                                                              showCard();
                                                              // Show the warning
                                                              final snackbar = SnackBar(
                                                                content: Text('You cannot join your own post'),
                                                                duration: Duration(seconds: 2),
                                                              );
                                                              _scaffoldKey.currentState.showSnackBar(snackbar);
                                                              // If the user already joined
                                                            } else if(await DatabaseService().isAlreadyJoined(user.uid, doc.id)){
                                                                // Close the post description
                                                                showCard();
                                                                final snackbar = SnackBar(content: Text('You already joined in this cause'));
                                                                _scaffoldKey.currentState.showSnackBar(snackbar);
                                                            } else{

                                                              bool isDateSet = false;
                                                              var dateColor = Colors.white70;
                                                              // pop up a dialog to choose the desired date to go to transfusion center
                                                              showGeneralDialog(
                                                                  context: context,
                                                                  barrierLabel: "",
                                                                  barrierColor: Colors.black.withOpacity(0.4),
                                                                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){},
                                                                  transitionDuration: Duration(milliseconds: 700),
                                                                  transitionBuilder: (context, animation, secondaryAnimation, child){
                                                                    // the transition of the dialog window
                                                                    return ScaleTransition(
                                                                      scale: CurvedAnimation(
                                                                          parent: animation,
                                                                          curve: Curves.elasticOut,
                                                                          reverseCurve: Curves.easeInOutBack
                                                                      ),
                                                                      // the Dialog window
                                                                      // has a text and two buttons, one which chooses the date of the notification
                                                                      // and the other finishes the process
                                                                      child: Dialog(
                                                                        backgroundColor: Color(0xFF9dd9d2),
                                                                        insetAnimationDuration: Duration(milliseconds: 1700),
                                                                        insetAnimationCurve: Curves.easeInOutSine,
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                        child: Container(
                                                                          width: windowWidth,
                                                                          height: windowHeight*0.3,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              // the elements from the window
                                                                              Text('Choose the date of the transfusion'),
                                                                              RaisedButton(
                                                                                color: dateColor,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                                                                child: Text('Choose date'),
                                                                                onPressed: (){
                                                                                  showDatePicker(
                                                                                      context: context,
                                                                                      initialDate: DateTime.now(),
                                                                                      firstDate: DateTime(2021),
                                                                                      lastDate: DateTime(2025)
                                                                                  ).then((date) => {
                                                                                    print('it works here'),
                                                                                    LocalNotifications().showNotification(date),
                                                                                    isDateSet = true,
                                                                                    dateColor = Color(0xff9CD8A9)

                                                                                  }
                                                                                  );
                                                                                },
                                                                              ),
                                                                              RaisedButton(
                                                                                  color: Color(0xFFD89CA3),
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                                                                  child: Text('Finish!') ,
                                                                                  onPressed: () async{
                                                                                    if(isDateSet) {
                                                                                      Navigator.pop(context);
                                                                                      // Add the user to the joined people
                                                                                      DatabaseService().addPeopleToPost(user.uid, doc.id);
                                                                                      // Send a notification to the author of the post regarding joining his cause
                                                                                      await NotificationService().sendJoinNotification(_postAuthorDeviceToken);
                                                                                      // Close the post and show a snackbar
                                                                                      showCard();
                                                                                      final snackbar = SnackBar(content: Text('You joined the cause!'),);
                                                                                      _scaffoldKey.currentState.showSnackBar(snackbar);
                                                                                    }
                                                                                  }
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                              );
                                                            }
                                                          },
                                                          width: windowWidth/3.5,
                                                          height: windowHeight/18,
                                                          text: 'Join',
                                                          color: Color(0xFF9dd9d2),
                                                          textColor: Colors.black,
                                                          borderColor: Color(0xFF9dd9d2),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                //! Space between buttons and bottom
                                                Expanded(flex: 5, child: Text('')),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                        );
                      },
                    ),
                  ),
              ]
          ),

          //! Create post page
          AnimatedContainer(
            padding: EdgeInsets.fromLTRB(32, 32, 32, 0),
            height: _createPostHeight,
            width: _createPostWidth,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
                milliseconds: 1000
            ),
            transform: Matrix4.translationValues(_createPostXOffset, _createPostYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                )
            ),
            child: Column(
              children: <Widget>[
                  //! Title of the page
                  Expanded(
                        flex: 10,
                        child: Text(
                          "Create a post",
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),
                  //! Empty space
                  Expanded(
                    flex: 10,
                    child: Text(''),
                  ),
                  //! Hospital input
                  Expanded(
                    flex: 15,
                    child: CustomInput(
                      width: windowWidth*0.8,
                      color: Colors.grey[350],
                      controller: hospitalController,
                      obscured: false,
                      hint: 'hospital',
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  //! Empty space
                  Expanded(
                    flex: 10,
                    child: Text(''),
                  ),
                  //! Description input
                  Expanded(
                    flex: 60,
                    child: CustomInput(
                        width: windowWidth*0.8,
                        color: Colors.grey[350],
                        controller: descriptionController,
                        height: windowHeight*0.25,
                        obscured: false,
                        hint: 'description',
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                    ),
                  ),
                  //! Empty space
                  Expanded(
                    flex: 10,
                    child: Text(''),
                  ),
                  //! Expiration date button
                  Expanded(
                  flex: 13,
                  child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: RaisedButton(
                      color: Colors.red[800],
                      child: Text(
                        expirationDateText,
                        style: TextStyle(
                            color: Colors.grey[300]
                        ),
                      ),
                      onPressed: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime(2025)
                        ).then((date) => {
                          _dateTime = date,
                          expirationDateText = DateFormat('dd.MM.yyyy').format(date) });
                      },
                    ),
                  ),
                ),
                  //! Empty space
                  Expanded(
                    flex: 30,
                    child: Text(''),
                  ),
                  //! Cancel and Done button row
                  Expanded(
                    flex: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //! Back button
                        Container(
                          margin: EdgeInsets.all(10),
                          child: outlineButton.OutlineButton(
                            onPressed: (){
                              setState((){
                                _pageState = 0;
                              });
                            },
                            text: 'Cancel',
                            fontSize: windowWidth*0.035,
                            width: windowWidth*0.25,
                            height: windowWidth*0.1,
                            textColor: Colors.black,
                            color: Colors.white,
                            borderColor: Colors.red[800],

                          ),
                        ),

                        //! Done button
                        Container(
                            margin: EdgeInsets.all(10),
                            child: outlineButton.OutlineButton (
                              height: windowWidth*0.1,
                              width: windowWidth*0.25,
                              fontSize: windowWidth*0.035,
                              color: Colors.red[800],
                              textColor: Colors.grey[300],
                              borderColor: Colors.red[800],
                              onPressed: () async{

                                // the expiration date is before the current date
                                if(_dateTime.compareTo(DateTime.now()) <= 0){
                                  SnackBar snackbar = SnackBar(content: Text('Invalid expiration date, choose another!'));
                                  _scaffoldKey.currentState.showSnackBar(snackbar);
                                }
                                else if(descriptionController.text.isEmpty || hospitalController.text.isEmpty){
                                  SnackBar snackbar = SnackBar(content: Text('Complete all fields!'));
                                  _scaffoldKey.currentState.showSnackBar(snackbar);
                                }
                                else {
                                  //! get the user from the session
                                  User user = FirebaseAuth.instance.currentUser;
                                  //! get the user details from the database
                                  //! will use the 'name' and 'bloodtype' fields
                                  DocumentSnapshot userDetails = await FirebaseFirestore
                                      .instance.collection('users').doc(
                                      user.uid).get();

                                  //! Format the date to hide the hours and minutes
                                  String expirationDateFormat = DateFormat(
                                      "yyyy-MM-dd").format(_dateTime);
                                  String postDate = DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now());

                                  String hospital = hospitalController.text;
                                  String description = descriptionController.text;

                                  //! add the post to the user history
                                  try {
                                    FirebaseMessaging().getToken().then((
                                        token) =>
                                    {
                                      DatabaseService().addPostToUser(
                                          userDetails['name'],
                                          userDetails['bloodtype'],
                                          hospital,
                                          postDate,
                                          expirationDateFormat,
                                          description,
                                          user.uid,
                                          token
                                      )
                                    });

                                    // //! adds the post to the general user posts branch
                                    FirebaseMessaging().getToken().then((
                                        token) =>
                                    {
                                      DatabaseService().addPost(
                                          userDetails['name'],
                                          userDetails['bloodtype'],
                                          hospital,
                                          postDate,
                                          expirationDateFormat,
                                          description,
                                          userDetails['city'],
                                          user.uid,
                                          token,
                                          user.photoURL
                                      )
                                    });
                                    //! Send a notification to all users that have the same blood type
                                    NotificationService()
                                        .sendSimilarBloodJoinNotification(
                                        userDetails['bloodtype']);
                                  } on FirebaseException catch (e) {
                                    print(e.message);
                                  }
                                  setState(() {
                                    final snackbar = SnackBar(
                                      content: Text('Post created!'),
                                      duration: Duration(seconds: 2),
                                    );
                                    _scaffoldKey.currentState.showSnackBar(
                                        snackbar);

                                    hospitalController.clear();
                                    descriptionController.clear();
                                    _pageState = 0;
                                  });
                                }
                              },
                              text: "Done",
                            )
                        ),
                      ],
                    ),
                  ),
              ]
          )
      ),
      ]
    )
    );
  }
}

Future<dynamic> _onBackgroundMessage(Map<String, dynamic> message) async {
  debugPrint('On background message $message');
  return Future<void>.value();
}
