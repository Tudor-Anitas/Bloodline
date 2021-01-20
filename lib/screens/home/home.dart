import 'package:BloodLine/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(
        milliseconds: 700
        ),
        color: Colors.white,
        child: FlatButton(
          onPressed: (){
            context.read<AuthService>().signOut();
          },
          child: Center(
            child: Text('Log out'),
          ),
        ),
      ),
    );
  }
}
