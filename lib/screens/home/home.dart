import 'package:BloodLine/screens/authenticate/authenticate.dart';
import 'package:BloodLine/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Post.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {

  List<Post> posts = [
    Post(Container(decoration: const BoxDecoration(color: Colors.pink)),
  'Tudor Anitas', 'AB+', 'Baia Mare', '25.03.2021', "some description here for this patient"),
    Post(Container(decoration: const BoxDecoration(color: Colors.blue)),
        'Tudor Anitas', 'AB+', 'Baia Mare', '25.03.2021', "again some description poor bastard")
  ];


  int _pageState = 0; // decides if it is a welcome, login or register
  var _backgroundColor = Colors.white; // changes the background color of a state widget
  double windowWidth = 0; // the width of the screen
  double windowHeight = 0; // the height of the screen

  double _postsHeight = 0;
  double _postsWidth = 0;
  double _postsXOffset = 0; // the offset of the login page to the top side
  double _postsYOffset = 0;// the offset of the login page to the left side
  Radius _postsBottomLeft = Radius.circular(0);
  Radius _postsBottomRight = Radius.circular(0);

  double _createPostHeight = 0;
  double _createPostWidth = 0;
  double _createPostXOffset = 0;
  double _createPostYOffset = 0;


  TextEditingController hospitalController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  DateTime _dateTime;
  String expirationDateText = 'Expiration date';

  @override
  Widget build(BuildContext context) {

    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;


    
    switch(_pageState){
      //? The posts menu
      case 0:
        _postsHeight = windowHeight - windowHeight/9;
        _postsWidth = windowWidth;
        _postsXOffset = 0;
        _postsYOffset = windowHeight/9;
        _postsBottomLeft = Radius.circular(0);
        _postsBottomRight = Radius.circular(0);

        _createPostHeight = 0;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight;
        break;
      case 1:
        _createPostHeight = windowHeight - windowHeight/5.5;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight/5.5;
        break;
      case 2:
        //? How will the Main page be displayed
        _postsHeight = windowHeight/2 ;
        _postsWidth = windowWidth;
        _postsXOffset = -windowWidth/2;
        _postsYOffset = -windowHeight/25;
        _postsBottomLeft = Radius.circular(25);
        _postsBottomRight = Radius.circular(25);

        _createPostHeight = 0;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight;
    }


    return Scaffold(
      body: Stack(
        children: [
          //! The posts page
          Scaffold(
            backgroundColor: Colors.red[800],
            //! Add a post button
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                  setState((){
                    _pageState = 1;
                  });
                },
              backgroundColor: Colors.red[800],
              child: Icon(Icons.add),
              splashColor: Colors.deepPurple,
            ),
            //! The white space where posts lay
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40),
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

                Expanded(
                  flex: 10,
                  child: AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(
                        milliseconds: 700
                    ),
                    transform: Matrix4.translationValues(_postsXOffset, _postsYOffset, 1),
                    width: _postsWidth,
                    height: _postsHeight,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: _postsBottomLeft,
                            bottomRight: _postsBottomRight
                        )
                    ),
                    //! The list of posts from the database
                    child: StreamBuilder<QuerySnapshot>(
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
                              return Card(
                                  child: CustomListTile(
                                    height: windowHeight*0.1,
                                    profileImage: Container(decoration: const BoxDecoration(color: Colors.pink)),
                                    name: doc['name'],
                                    bloodType: doc['bloodtype'],
                                    city: doc['hospital'],
                                    date: doc['date'],
                                  )
                              );
                            }
                        );
                      },

                    ),
          ),
                ),
              ],
            )
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
                      hint: 'hospital',
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
                        hint: 'description'
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
                          child: OutlineButton(
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
                            child: OutlineButton (
                              height: windowWidth*0.1,
                              width: windowWidth*0.25,
                              fontSize: windowWidth*0.035,
                              color: Colors.red[800],
                              textColor: Colors.grey[300],
                              borderColor: Colors.red[800],
                              onPressed: () async{
                                //! get the user from the session
                                User user = FirebaseAuth.instance.currentUser;
                                //! get the user details from the database
                                //! will use the 'name' and 'bloodtype' fields
                                DocumentSnapshot userDetails = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

                                //! Format the date to hide the hours and minutes
                                String expirationDateFormat = DateFormat("dd.MM.yyyy").format(_dateTime);
                                String postDate = DateFormat("dd.MM.yyyy").format(DateTime.now());

                                //! add the post to the user history
                                try {
                                  DatabaseService().addPostToUser(
                                      userDetails['name'],
                                      userDetails['bloodtype'],
                                      hospitalController.text,
                                      postDate,
                                      expirationDateFormat,
                                      descriptionController.text,
                                      user.uid);

                                  //! adds the post to the general user posts branch
                                  DatabaseService().addPost(
                                      userDetails['name'],
                                      userDetails['bloodtype'],
                                      hospitalController.text,
                                      postDate,
                                      expirationDateFormat,
                                      descriptionController.text,
                                      user.uid);
                                } on FirebaseException catch(e){
                                  print(e.message);
                                }
                                setState(()  {
                                  hospitalController.clear();
                                  descriptionController.clear();
                                  _pageState = 0;
                                });
                              },
                              text: "Done",

                            )
                        ),
                      ],
                    ),
                  ),
              ]
          )
      )
      ]
    )
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


  CustomListTile({
    Key key,
    this.profileImage,
    this.name,
    this.bloodType,
    this.city,
    this.date,
    this.height
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 5,
        shadowColor: Colors.grey,
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
                  )
                ],
              ),
              ),
        )
      )
    );
  }

}

//? classes for custom inputs used for creating posts
class CustomInput extends StatefulWidget{
  final String hint;
  final TextEditingController controller;
  final Color color;
  final double height;
  final double width;
  CustomInput({
    this.hint,
    this.controller,
    this.color,
    this.height,
    this.width
  });
  @override
  _CustomInputState createState() => _CustomInputState();
}
class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.color,
              width: 2
          ),
          borderRadius: BorderRadius.circular(14)
      ),
      child: Row(
        children: <Widget>[
          // the input space
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 10,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: InputBorder.none,
                hintText: widget.hint
              ),
            ),
          )
        ],
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
          borderRadius: BorderRadius.circular(50)
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
