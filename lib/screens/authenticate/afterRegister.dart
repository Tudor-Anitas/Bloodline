import 'package:BloodLine/screens/splash/loadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodLine/screens/home/home.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

    //? The width of the device screen
    double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: AnimatedContainer(
          duration: Duration(milliseconds: 700),
          curve: Curves.bounceIn,
          decoration: BoxDecoration(
              color: Color(0xFF9dd9d2)
          ),
          child: Column(
            children: [
              //! Empty space
              Expanded(child: Text(''), flex: 10,),
              //! The title of the page
              Expanded(
                flex: 20,
                child: Container(
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
              ),
              //! Empty space
              Expanded(child: Text(''), flex: 50,),
              //! Name input
              Expanded(
                flex: 15,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomInput(
                    width: windowWidth*0.7,
                    hint: 'Name',
                    obscured: false,
                    controller: nameController,
                    color: Colors.white,
                  ),
                ),
              ),
              //! Empty space
              Expanded(child: Text(''), flex: 5,),
              //! Blood type
              Expanded(
                flex: 20,
                child: Container(
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
              ),
              //! Empty space
              Expanded(child: Text(''), flex: 30,),
              //! Done button
              Expanded(
                flex: 13,
                child: Container(
                  child: PrimaryButton(
                    width: windowWidth*0.7,
                    buttonText: 'Done!',
                    color: Colors.black,
                    onPressed: (){
                      FirebaseMessaging().getToken().then((token) => {
                          AuthService(FirebaseAuth.instance).updateNameAndBloodType(
                              nameController.text.trim(),
                              bloodtypeValue,
                              token
                          )
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loading()));
                    },
                  ),
                ),
              ),
              //! Empty space
              Expanded(child: Text(''), flex: 10,)
            ],
          ),
      ),
    );
  }

}