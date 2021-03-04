
import 'package:BloodLine/services/local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget{

  var width;
  var height;

  CustomDialog({
      this.width,
      this.height
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomDialogState();
  }
}

class _CustomDialogState extends State<CustomDialog>{

  bool isDateSet = false;
  var dateColor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF9dd9d2),
      insetAnimationDuration: Duration(milliseconds: 1700),
      insetAnimationCurve: Curves.easeInOutSine, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: widget.width,
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Choose the date of the transfusion'),
            RaisedButton(
              color: dateColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              child: Text('Choose date'),
              onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2025)
                ).then((date) => {
                  print('it works here'),
                  LocalNotifications().showNotification(date),
                  isDateSet = true,
                  dateColor = Color(0xff9CD8A9)
                  //Navigator.pop(context)
                }
                );
              },
            ),
            RaisedButton(
              color: Color(0xFFD89CA3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              child: Text('Finish!') ,
              onPressed: (){
                if(isDateSet) {
                  Navigator.pop(context);
                }
              }
            )
          ],
        ),
      ),
    );
  }

}