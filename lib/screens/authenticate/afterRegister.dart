import 'package:BloodLine/screens/splash/loadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodLine/screens/home/home.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BloodLine/screens/authenticate/authenticate.dart';

class Details extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _DetailsState();
}

class _DetailsState extends State<Details>{

  //? Controllers for text input
  TextEditingController nameController = TextEditingController();
  TextEditingController bloodtypeController = TextEditingController();

  //? The value shown as the representative in the dropdown
  String bloodtypeValue;
  //? The available blood types to choose from
  List bloodtypes = [
    "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
          duration: Duration(milliseconds: 700),
          curve: Curves.bounceIn,
          decoration: BoxDecoration(
              color: Color(0xFF9dd9d2)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //! The title of the page
              Container(
                margin: EdgeInsets.only(top: 80.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Help us know you better!',
                      style: TextStyle(
                          fontSize: 26.0
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    margin: EdgeInsets.only(bottom: 20),
                    child: CustomInput(
                      hint: 'Name',
                      controller: nameController,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: DropdownButton(
                        hint: Text('Blood Type'),
                        value: bloodtypeValue,
                        items: bloodtypes.map((type){
                          return DropdownMenuItem(
                              child: Text(type),
                              value: type,
                          );
                        }).toList(),
                        onChanged: (newValue){
                          setState((){
                             bloodtypeValue = newValue;
                          });
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 100),

                    child: PrimaryButton(
                      buttonText: 'Done!',
                      color: Colors.black,
                      onPressed: (){
                        AuthService(FirebaseAuth.instance).updateNameAndBloodType(
                            nameController.text.trim(),
                            bloodtypeValue);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loading()));
                      },
                    ),
                  ),

                ]
              ),

            ],
          ),
      ),
    );
  }

}