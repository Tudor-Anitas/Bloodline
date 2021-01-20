import 'package:BloodLine/screens/authenticate/authenticate.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
                milliseconds: 700
            ),
            color: Colors.white,
            child: FlatButton(
              onPressed: (){
                context.read<AuthService>().signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              child: Center(
                child: Text('Log out'),
              ),
            ),
          ),
        ],
      )

    );
  }
}
