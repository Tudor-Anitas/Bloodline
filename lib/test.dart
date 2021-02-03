
import 'package:cloud_firestore/cloud_firestore.dart';
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


    return Scaffold(
      body: Stack(
        children: [
          //! The posts page
          AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
                milliseconds: 700
            ),
            transform: Matrix4.translationValues(_postsXOffset, _postsYOffset, 1),
            width: windowWidth,
            height: windowHeight,
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
                            color: Colors.white,
                            profileImage: Container(decoration: const BoxDecoration(color: Colors.pink)),
                            name: doc['name'],
                            bloodType: doc['bloodtype'],
                            city: doc['hospital'],
                            date: doc['date'],
                            onTap: (){
                              setState(() {
                                //? Set the opening screen with the custom information about the related post
                                _postAuthor = doc['name'];
                                _postHospital = doc['hospital'];
                                _postBloodType = doc['bloodtype'];
                                _postDate = doc['date'];
                                _postDescription = doc['description'];
                                _postExpirationDate = doc['expiration-date'];

                                _pageState = 1;

                              });
                            },
                          )
                      );
                    }
                );
              },
            ),
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.bounceOut,
              transform: Matrix4.translationValues(_postXOffset, _postYOffset, 1),
              width: windowWidth,
              height: _postPageHeight,

              child: Transform.scale(
                scale: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45)
                      )
                  ),
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        _pageState = 0;
                      });
                    },
                    child: Text('back'),
                  ),
                ),
              ),
          )
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