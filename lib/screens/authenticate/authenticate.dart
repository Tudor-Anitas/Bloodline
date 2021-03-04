import 'package:BloodLine/screens/home/home.dart';
import 'package:BloodLine/screens/splash/loadingScreen.dart';
import 'package:BloodLine/services/auth.dart';
import 'package:BloodLine/widgets/customInput.dart';
import 'package:BloodLine/widgets/outlineButton.dart' as outlineButton;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:BloodLine/screens/authenticate/afterRegister.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{

  int _pageState = 0; // decides if it is a welcome, login or register
  var _backgroundColor = Colors.white; // changes the background color of a state widget
  var _headerColor = Colors.black; // the text color of the header text

  String _headline; // either "Login" or "Register"
  String _description;

  double windowWidth = 0; // the width of the screen
  double windowHeight = 0; // the height of the screen

  double _loginHeight = 0;
  double _loginWidth = 0;
  double _loginXOffset = 0; // the offset of the login page to the top side
  double _loginYOffset = 0;// the offset of the login page to the left side
  double _loginOpacity = 1;

  double _registerHeight = 0;
  double _registerYOffset = 0; // the offset of the register page to the top side
  double _headlineMargin = 0; // the offset of the header to the top

  bool _keyboardVisible = false;
  var img;
  var signInEmail = TextEditingController();
  var signInPassword = TextEditingController();
  var signUpEmail = TextEditingController();
  var signUpPassword = TextEditingController();

  FirebaseAuth _auth;

  List<String> headlines = ["Text here", "Login", "Register"];


  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    // get the size of the screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;



    switch(_pageState){

      case 0: // welcome page
        _backgroundColor = Colors.white;
        _headerColor = Colors.black;
        // Text to be changed
        _headline = headlines[0];
        _description = "Text description about the blood donation in romania";

        // the X and Y offset of the panel
        _loginXOffset = 0;
        _loginYOffset = windowHeight;
        _registerYOffset = windowHeight;
        _headlineMargin = 100;

        _loginWidth = windowHeight;
        // _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 250;
        img = Image.asset('assets/images/welcome.png', fit: BoxFit.contain,);
        break;

      case 1: // login page

        _headline = headlines[1]; // displays "Login" in the headline
        _description = ""; // removes the description under the header

        _backgroundColor = Color(0xFF392F5A); // colors the background to purple
        _headerColor = Colors.white; // font color of the headline

        _headlineMargin = windowHeight - windowHeight/1.15; // margin of the headline to the top

        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - windowHeight/4; // the height of the login card that stores the input and buttons
        _loginWidth = windowWidth;
        _loginXOffset = 0; // how far right does the panel go
        _loginYOffset = _keyboardVisible ? windowHeight - windowHeight/1.2 : windowHeight - windowHeight/1.5; // how far downwards does the card go while the keyboard is active
        _loginOpacity = 1;

        _registerYOffset = windowHeight;

        img = Text("");
        break;

      case 2: // the register page
        _headline = headlines[2]; // displays "Register" in the headline
        _description = ""; // removes the description under the header

        _backgroundColor = Color(0xFF9dd9d2); // background color of the main screen
        _headerColor = Colors.white; // the font color of the headline

        _headlineMargin = 140; // margin of the headline to the top

        _loginWidth = windowWidth - 40; // the width of the login card behind the register card
        _loginOpacity = 0.7;

        _loginYOffset = _keyboardVisible ? 120 : 240; // the offset of the login card according to the keyboard activity
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270; // the height of login card

        _loginXOffset = 20; // offset of the login card on X axis
        _registerYOffset = _keyboardVisible ? 120 : 270; // how far upward does the register card go when the keyboard is activated
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270; // the height of the register card
        break;
    }

    return new Scaffold(
      body:Stack(
        children: [


          // welcome page for the user
          AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 700
          ),
          color: _backgroundColor,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text container
              Container(
                child: Column(
                  children: [

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 0;
                        });
                      },
                      child: AnimatedContainer(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(
                              milliseconds: 700
                          ),
                          margin: EdgeInsets.only(
                            top: _headlineMargin,
                          ),
                          child: Text(
                            _headline,
                            style: TextStyle(
                                color: _headerColor,
                                fontSize: 30,
                                fontFamily: "Nunito"
                            ),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.all(32),
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Image container
              Container(
                padding: EdgeInsets.symmetric(horizontal: 75.0),
                child: Center(
                  child: img
                )
              ),
              // Button container
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(32),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xff392F5A),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

          //! login page
          AnimatedContainer(
            padding: EdgeInsets.all(32),
            height: _loginHeight,
            width: _loginWidth,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(
                milliseconds: 1000
            ),
            transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_loginOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                )
            ),
            //! The start of the page
            child: Column(

              children: <Widget>[
                Expanded(
                  flex: 50,
                  child: Container(
                    child: Text(
                      "Login To Continue",
                      style: TextStyle(
                          fontSize: windowWidth/20
                      ),
                    ),
                  ),
                ),

                //! Email input
                Expanded(
                  flex: 40,
                  child: CustomInput(
                    width: windowWidth*0.8,
                    height: windowHeight*0.01,
                    hint: "Enter Email...",
                    color: Colors.grey,
                    obscured: false,
                    controller: signInEmail,
                  ),
                ),
                //! Empty space
                Expanded(child: Text(''), flex: 10,),
                //! Password input
                Expanded(
                  flex: 40,
                  child: CustomInput(
                    width: windowWidth*0.8,
                    height: windowHeight*0.01,
                    hint: "Enter Password...",
                    color: Colors.grey,
                    obscured: true,
                    controller: signInPassword,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                  ),
                ),
                //! Empty space
                Expanded(
                  flex: 5,
                  child: Text(''),
                ),
                //! Google and Fb icons
                Expanded(
                  flex: 20,
                  child: Row(
                    children: [
                      //! Google auth
                      IconButton(
                          icon: Icon(Icons.details),
                          onPressed: () async {
                            try{
                              if(await AuthService(_auth).signInWithGoogle()){
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) => Loading()));
                              }else{
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Details()));
                              }
                            }
                            catch(e){
                              print(e);
                            }
                        },
                      ),
                      //! Facebook auth
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async{
                          try{
                            if(await AuthService(_auth).signInWithFacebook()){
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => Loading()));
                            }else{
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Details()));
                            }
                          }
                          catch(e){
                            print(e);
                          }
                        },
                      )
                    ],
                  ),
                ),
                //! Empty space
                Expanded(child: Text(''), flex: 40,),
                //! Login button
                Expanded(
                flex: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff392F5A),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(10),
                  child: FlatButton(
                    onPressed: (){
                      context.read<AuthService>().signIn(
                        email: signInEmail.text.trim(),
                        password: signInPassword.text.trim()
                      );

                    },
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                //! Empty space
                Expanded(child: Text(''), flex: 20,),
                //! Go to register button
                Expanded(
                flex: 40,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 2;
                    });

                  },
                  child: outlineButton.OutlineButton(
                    text: "Create New Account",
                    color: Colors.white,
                    textColor: Color(0xff392F5A),
                    borderColor: Color(0xff392F5A),
                  ),
                ),
              ),
                //! Empty space
                Expanded(child: Text(''), flex: 50,),
            ],
          ),
        ),

          //! register page
          AnimatedContainer(
          height: _registerHeight,
          padding: EdgeInsets.all(32),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
              milliseconds: 1000
          ),
          transform: Matrix4.translationValues(0, _registerYOffset, 1),
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
                //! Title
                Expanded(
                  flex: 50,
                  child: Container(
                    child: Text(
                      "Create a New Account",
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
                //! Email input
                Expanded(
                  flex: 40,
                  child: CustomInput(
                    width: windowWidth*0.8,
                    height: windowHeight*0.01,
                    color: Color(0xFF9dd9d2),
                    hint: "Enter Email...",
                    obscured: false,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: signUpEmail,
                  ),
                ),
                Expanded(child: Text(''), flex: 10,),
                //! Password input
                Expanded(
                  flex: 40,
                  child: CustomInput(
                    width: windowWidth*0.8,
                    height: windowHeight*0.01,
                    color: Color(0xFF9dd9d2),
                    hint: "Enter Password...",
                    obscured: true,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    controller: signUpPassword,
                  ),
                ),
                Expanded(child: Text(''), flex: 65,),
                //! Register button
                Expanded(
                  flex: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF9dd9d2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: (){
                        try {
                          context.read<AuthService>().signUp(
                              email: signUpEmail.text,
                              password: signUpPassword.text
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Details()));
                        } catch(e){
                          print(e.toString());
                        }

                      },
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Text(''), flex: 20,),
                //! Back to login button
                Expanded(
                  flex: 40,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _pageState = 1;
                      });

                    },
                    child: outlineButton.OutlineButton(
                      text: "Back To Login",
                      color: Colors.white,
                      textColor: Color(0xff777777),
                      borderColor: Color(0xFF9dd9d2),
                    ),
                  ),
                ),

            ],
          ),
        ),

        ],
      )
    );
  }

}

//? classes for buttons on the login and register page
class PrimaryButton extends StatefulWidget{

  Color color = Color(0xff392F5A); // the color of the primary button
  final String buttonText; // text inside the button
  final Function onPressed;
  final double width;
  final double height;
  final double fontSize;
  PrimaryButton({
    this.buttonText,
    this.color,
    this.width,
    this.height,
    this.fontSize,
    this.onPressed
  });

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();

}
class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(10),
      child: Center(
          child: FlatButton(
            onPressed: widget.onPressed,

            child: Text(
              widget.buttonText,
              style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: widget.fontSize
              ),
            ),
          )

        )
    );
  }
}

// //? classes for contrast, secondary buttons
// class OutlineButton extends StatefulWidget{
//   String text; // what text to display inside the button
//   Color color = Colors.black; // what color should be inside that button
//   Color textColor = Colors.white;
//   Color borderColor = Colors.black;
//   final Function onPressed;
//   OutlineButton({
//     this.text,
//     this.color,
//     this.textColor,
//     this.borderColor,
//     this.onPressed
//   });
//
//
//   @override
//   _OutlineButtonState createState() => _OutlineButtonState();
//
// }
// class _OutlineButtonState extends State<OutlineButton>{
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: widget.borderColor,
//               width: 2
//           ),
//           color: widget.color,
//           borderRadius: BorderRadius.circular(50)
//       ),
//       padding: EdgeInsets.all(20),
//       child: Center(
//         child: FlatButton(
//           onPressed: widget.onPressed,
//           child: Text(
//             widget.text,
//             style: TextStyle(
//                 color: widget.textColor,
//                 fontSize: 16
//             ),
//           ),
//         ),
//       ),
//
//     );
//   }
// }

//? classes for custom inputs used for login and register
class InputWithIcon extends StatefulWidget{
  final IconData icon;
  final String hint;
  final bool obscured;
  final double width;
  final double height;
  final double iconSize;
  final TextEditingController controller;

  InputWithIcon({
    this.icon,
    this.hint,
    this.obscured,
    this.width,
    this.height,
    this.iconSize,
    this.controller,
  });
  @override
  _InputWithIconState createState() => _InputWithIconState();
}
class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: <Widget>[
          // the icon of the input
          Container(
              width: 60,
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: Color(0xFFBB9B9B9),
              )
          ),
          // the input space
          Expanded(
            child: TextField(
              obscureText: widget.obscured,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                border: InputBorder.none,
                hintText: widget.hint,

              ),
            ),
          )
        ],
      ),
    );
  }
}
