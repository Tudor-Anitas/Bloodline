
import 'package:BloodLine/screens/authenticate/authenticate.dart';
import 'package:BloodLine/screens/splash/loadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {

  const Wrapper({
    Key key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // return either Home or Authenticate widget
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      return MaterialApp(
        theme: ThemeData(
            fontFamily: "Nunito"
        ),
        debugShowCheckedModeBanner: false,
        home: Loading(),
      );
    }
    return MaterialApp(
        theme: ThemeData(
            fontFamily: "Nunito"
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
    );

  }
}
