import 'package:BloodLine/screens/authenticate/authenticate.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:BloodLine/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
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

  double _createPostHeight = 0;
  double _createPostWidth = 0;
  double _createPostXOffset = 0;
  double _createPostYOffset = 0;


  TextEditingController hospitalController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {

    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;


    
    switch(_pageState){
      //? The posts menu
      case 0:
        _postsHeight = windowHeight - 170;
        _postsWidth = windowWidth;
        _postsXOffset = 0;
        _postsYOffset = 170;

        _createPostHeight = 0;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = windowHeight;
        break;
      case 1:
        _createPostHeight = windowHeight - 170;
        _createPostWidth = windowWidth;
        _createPostXOffset = 0;
        _createPostYOffset = 170;
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
            body: AnimatedContainer(
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
                      topRight: Radius.circular(25)
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
          )
          ),
          AnimatedContainer(
            padding: EdgeInsets.all(32),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Create a post",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    CustomInput(
                      controller: hospitalController,
                      hint: 'hospital',
                    ),
                    SizedBox(height: 20,),
                    CustomInput(
                      controller: descriptionController,
                      hint: 'description'
                    ),
                    Container(
                      child: RaisedButton(
                        child: Text('Expiration date'),
                        onPressed: (){
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2025)
                          ).then((date) => _dateTime = date);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //! Back button
                        Container(
                            margin: EdgeInsets.all(10),
                            child: FlatButton(
                                onPressed: (){
                                  setState((){
                                    _pageState = 0;
                                  });
                                },
                                child: Text("back"))
                        ),
                        //! Logout button
                        Container(
                            margin: EdgeInsets.all(10),
                            child: RaisedButton(
                                onPressed: (){
                                  context.read<AuthService>().signOut();
                                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                },
                                child: Text("logout"))
                        ),
                        //! Done button
                        Container(
                            margin: EdgeInsets.all(10),
                            child: FlatButton (
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
                                child: Text("done"))
                        )
                      ],
                    )

                  ]
                )
              ],
            ),
          )

        ],

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


  CustomListTile({
    Key key,
    this.profileImage,
    this.name,
    this.bloodType,
    this.city,
    this.date
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
                height: 75.0,
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
                        Expanded(
                            flex: 3,
                            child: Text(city)),
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
  CustomInput({
    this.hint,
    this.controller,
  });
  @override
  _CustomInputState createState() => _CustomInputState();
}
class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: <Widget>[
          // the input space
          Expanded(
            child: TextField(
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

