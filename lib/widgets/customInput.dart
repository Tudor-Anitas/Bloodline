
//? classes for custom inputs used for creating posts
// ignore: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget{
  final String hint;
  final TextEditingController controller;
  final Color color;
  final double height;
  final double width;
  final TextInputType keyboardType;
  int minLines = 1;
  int maxLines = 1;
  final obscured;

  CustomInput({
    this.hint,
    this.controller,
    this.color,
    this.height,
    this.width,
    this.obscured,
    this.keyboardType,
    this.minLines,
    this.maxLines
  });
  @override
  _CustomInputState createState() => _CustomInputState();
}
class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.color,
              width: 2
          ),
          borderRadius: BorderRadius.circular(14)
      ),
      child: Row(
        children: <Widget>[
          // the input space
          Expanded(
            child: TextField(
              keyboardType: widget.keyboardType,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              controller: widget.controller,
              obscureText: widget.obscured,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: InputBorder.none,
                  hintText: widget.hint
              ),
            ),
          )
        ],
      ),
    );
  }
}