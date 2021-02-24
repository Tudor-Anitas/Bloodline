import 'package:BloodLine/services/database.dart';
import 'package:BloodLine/services/notifications.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class Testpage extends StatefulWidget{

  @override
  _TestpageState createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {


  double _postsHeight = 0;
  double _postsWidth = 0;
  double _postsXOffset = 0; // the offset of the login page to the top side
  double _postsYOffset = 0;// the offset of the login page to the left side
  double _postsOpacity = 1;
  Radius _postsBottomLeft = Radius.circular(0);
  Radius _postsBottomRight = Radius.circular(0);


  //? To be added to the home page
  double _postPageHeight = 0;
  double _postPageWidth = 0;
  double _postXOffset = 0;
  double _postYOffset = 0;
  // Fields that change dynamically when a Post button is pressed
  String _postBloodType = '';
  String _postDate = '';
  String _postDescription = '';
  String _postExpirationDate = '';
  String _postHospital = '';
  String _postAuthor = '';
  String _postCity = '';



  double windowHeight;
  double windowWidth;

  int _pageState = 0;


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;


    switch(_pageState){
      case 0:
        _postPageHeight = 0;
        _postBloodType = '';
        _postDate = '';
        _postDescription = '';
        _postExpirationDate = '';
        _postHospital = '';
        _postAuthor = '';

        break;
      case 1:
        _postPageHeight = windowHeight/1.4;
        _postXOffset = 0;
        _postYOffset = 0;
        break;
    }
    final snackbar1 = SnackBar(content: Text('You already joined this cause!'));
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FirebaseAuth auth = FirebaseAuth.instance;

          //FirebaseMessaging().subscribeToTopic('Opos');
          DatabaseService().userExists(auth.currentUser.email);
        },
        
      ),
      body: Stack(
        children: [
            //! The posts page
            StreamBuilder<QuerySnapshot>(
              //! creates the connection to the posts branch
              stream: FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Center();
                //! if there are posts in the database
                //! create a ListView that is filled with Cards
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index){
                      //! doc is the individual Post from the database
                      final doc = snapshot.data.docs[index];
                      return OpenContainer(
                        transitionDuration: Duration(milliseconds: 500),
                          closedBuilder: (context, showDetails) {
                            return Card(
                                child: CustomListTile(
                                  height: windowHeight * 0.1,
                                  color: Colors.white,
                                  profileImage: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.blueAccent)),
                                  name: doc['name'],
                                  bloodType: doc['bloodtype'],
                                  city: doc['hospital'],
                                  date: doc['date'],
                                  onTap: () {
                                    //? Set the opening screen with the custom information about the related post
                                    _postAuthor = doc['name'];
                                    _postHospital = doc['hospital'];
                                    _postBloodType = doc['bloodtype'];
                                    _postDate = doc['date'];
                                    _postDescription = doc['description'];
                                    _postExpirationDate =
                                    doc['expiration-date'];
                                  },
                                )
                            );
                          },
                        openBuilder: (context, showCard){
                            //? Set the opening screen with the custom information about the related post
                            _postAuthor = doc['name'];
                            _postHospital = doc['hospital'];
                            _postBloodType = doc['bloodtype'];
                            _postDate = doc['date'];
                            _postDescription = doc['description'];
                            _postExpirationDate =
                            doc['expiration-date'];
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
                                          Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(70),
                                                  color: Colors.blueAccent,
                                              )
                                          ),
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
                                          Expanded(flex: 5, child: Text('')),
                                          //! Bloodtype
                                          //! Hospital
                                          //! City
                                          //! Expiration
                                          //! It has a Row with 2 Columns, one with the type of information and one with user info
                                          Expanded(
                                            flex: 25,
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
                                                            Text('Hospital'),
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
                                                            Text(_postHospital),
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
                                                            Text(_postExpirationDate),
                                                          ],
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          //! Space between details and description
                                          Expanded(flex: 5, child: Text('')),
                                          //! Description
                                          Expanded(
                                            flex: 65,
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
                                                  OutlineButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        showCard();
                                                      });
                                                    },
                                                    width: windowWidth/4,
                                                    height: windowHeight/20,
                                                    text: 'back',
                                                    color: Colors.white,
                                                    textColor: Colors.black,
                                                    borderColor: Colors.red[800],
                                                  ),
                                                  //! Join button
                                                  OutlineButton(
                                                    onPressed: (){

                                                    },
                                                    width: windowWidth/3.5,
                                                    height: windowHeight/18,
                                                    text: 'Join',
                                                    color: Colors.red[800],
                                                    textColor: Colors.black,
                                                    borderColor: Colors.white,
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
        ],
      ),

    );

  }
}

//? the custom card which is used for created posts
class CustomListTile extends StatelessWidget{

  final Widget profileImage;
  final String name;
  final String bloodType;
  final String city;
  final String date;
  final double height;
  final Color color;
  final Function onTap;

  CustomListTile({
    Key key,
    this.profileImage,
    this.name,
    this.bloodType,
    this.city,
    this.date,
    this.height,
    this.color,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey,
      color: color,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //! The card is separated in 3 parts: 1 + 2 + 2 space
                    //! The profile image of the user
                    Expanded(
                      flex: 1,
                      child: profileImage,
                    ),
                    //! Column with name and the city of the user
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          //! Margin between the top of the box and the name
                          Expanded(child: Text(""), flex: 1,),
                          Expanded(
                              flex: 3,
                              child: Text(name)
                          ),
                          Flexible(
                              flex: 3,
                              child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    city,
                                    overflow: TextOverflow.ellipsis,
                                  )
                              )
                          ),
                        ],
                      ),
                    ),
                    //! Column with the blood type and the date
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(child: Text(""), flex: 1,),
                          Expanded(
                              flex: 3,
                              child: Text(bloodType)
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(date))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

}

//? classes for contrast, secondary buttons
class OutlineButton extends StatefulWidget{
  String text; // what text to display inside the button
  Color color = Colors.black; // what color should be inside that button
  Color textColor = Colors.white;
  Color borderColor = Colors.black;
  double fontSize;
  double width;
  double height;
  final Function onPressed;
  OutlineButton({
    this.text,
    this.color,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.onPressed
  });


  @override
  _OutlineButtonState createState() => _OutlineButtonState();

}
class _OutlineButtonState extends State<OutlineButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.borderColor,
              width: 2
          ),
          color: widget.color,
          borderRadius: BorderRadius.circular(8)
      ),
      padding: EdgeInsets.all(2),
      child: Center(
        child: FlatButton(
          onPressed: widget.onPressed,
          highlightColor: Colors.red[700],
          child: Text(
            widget.text,
            style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize
            ),
          ),
        ),
      ),

    );
  }
}
