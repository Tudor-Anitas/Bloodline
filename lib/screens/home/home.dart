import 'package:BloodLine/screens/authenticate/authenticate.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Post.dart';


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


  TextEditingController cityController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

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
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index){
                  return Card(
                      child: CustomListTile(
                        profileImage: posts[index].profileImage,
                        name: posts[index].name,
                        bloodType: posts[index].bloodType,
                        city: posts[index].city,
                        date: posts[index].date,
                      )
                    );
                }
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
                      controller: cityController,
                      hint: 'city',
                    ),
                    SizedBox(height: 20,),
                    CustomInput(
                      controller: descriptionController,
                      hint: 'description'
                    ),
                    Container(
                        margin: EdgeInsets.all(50),
                        child: FlatButton(
                            onPressed: (){
                              setState((){
                                _pageState = 0;
                              });
                            },
                            child: Text("back"))
                    ),
                    Container(
                        margin: EdgeInsets.all(50),
                        child: FlatButton(
                            onPressed: (){
                              setState((){
                                  posts.add(
                                      Post(
                                        Container(decoration: const BoxDecoration(color: Colors.pink)),
                                        'Tot eu',
                                        'AB+',
                                        cityController.text.trim(),
                                        '23.03.2011',
                                        descriptionController.text.trim())
                                  );

                                  cityController.clear();
                                  descriptionController.clear();
                                  _pageState = 0;
                                });
                            },
                            child: Text("done"))
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

