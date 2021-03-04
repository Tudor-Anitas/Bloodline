
//? classes for contrast, secondary buttons
// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlineButton extends StatefulWidget{
  String text; // what text to display inside the button
  Color color = Colors.black; // what color should be inside that button
  Color textColor = Colors.white;
  Color borderColor = Colors.black;
  double fontSize;
  double width;
  double height;
  final Function onPressed;
  OutlineButton({
    this.text,
    this.color,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.fontSize,
    this.onPressed
  });


  @override
  _OutlineButtonState createState() => _OutlineButtonState();

}
class _OutlineButtonState extends State<OutlineButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.borderColor,
              width: 2
          ),
          color: widget.color,
          borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(2),
      child: Center(
        child: FlatButton(
          onPressed: widget.onPressed,
          highlightColor: Colors.red[700],
          child: Text(
            widget.text,
            style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize
            ),
          ),
        ),
      ),

    );
  }
}