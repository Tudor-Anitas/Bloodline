
//? the custom card which is used for created posts
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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