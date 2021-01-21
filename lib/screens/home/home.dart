import 'package:BloodLine/screens/authenticate/authenticate.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../Post.dart';


class Home extends StatelessWidget {

  List<Post> posts = [
    Post(Container(decoration: const BoxDecoration(color: Colors.pink)),
  'Tudor Anitas', 'AB+', 'Baia Mare', '25.03.2021'),
    Post(Container(decoration: const BoxDecoration(color: Colors.blue)),
        'Tudor Anitas', 'AB+', 'Baia Mare', '25.03.2021')
  ];

  int _pageState = 0; // decides if it is a welcome, login or register
  var _backgroundColor = Colors.white; // changes the background color of a state widget
  double windowWidth = 0; // the width of the screen
  double windowHeight = 0; // the height of the screen

  double _postsHeight = 0;
  double _postsWidth = 0;
  double _postsXOffset = 0; // the offset of the login page to the top side
  double _postsYOffset = 0;// the offset of the login page to the left side
  double _postsOpacity = 1;


  @override
  Widget build(BuildContext context) {

    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;


    
    switch(_pageState){
      //? The posts menu
      case 0:
        _postsHeight = windowHeight - 170;
        _postsWidth = windowHeight;
        _postsXOffset = 0;
        _postsYOffset = 170;

    }


    return Scaffold(
      body: Stack(
        children: [
          //! The posts page
          Scaffold(
            backgroundColor: Colors.red[800],
            floatingActionButton: FloatingActionButton(
              onPressed: (){},
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
                        Text(name),
                        Text(city)
                      ],
                    ),
                  ),
                  //! Column with the blood type and the date
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(bloodType),
                        Text(date)
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

