
import 'package:flutter/material.dart';

class OperatorButton extends StatelessWidget {
  const OperatorButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.enable,

     });
  final String text;
  final VoidCallback onPressed;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.teal,
      padding: EdgeInsets.all(5),
      disabledColor: Theme.of(context).disabledColor,
      onPressed: enable ? onPressed : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      minWidth: 130,
      height: 60,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20, color: enable ? Colors.white : Colors.grey,fontFamily: "IBMPlexSansArabic"),
      ),
    );
  }
}
