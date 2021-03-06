
import 'package:BloodLine/screens/wrapper.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Bloodline());
}


class Bloodline extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          
          StreamProvider(
              create: (context) => context.read<AuthService>().authStateChanges,
          )
        ],
        // Start the app inside the wrapper to know if there is a user logged in
        // of if there isn't one
        child: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if(!currentFocus.hasPrimaryFocus)
              currentFocus.unfocus();
          },
          child: MaterialApp(
              theme: ThemeData(
                  fontFamily: "Nunito"
              ),
              debugShowCheckedModeBanner: false,
              home: Wrapper()
          ),
        ));
  }
}
