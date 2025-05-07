import 'package:flutter/material.dart';

class Mystudentinfo extends StatelessWidget {
   Mystudentinfo({super.key, required this.type, required this.info});

 final String type ;
 final String info ; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
                height: 60,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(type,style: TextStyle(fontSize: 20),), Text(info,style: TextStyle(color: Colors.teal,fontSize: 20),)],
                ),
                decoration: BoxDecoration(
                  color: Color(0XFFF2F2F2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // shadow color
                      spreadRadius: 2, // how wide the shadow spreads
                      blurRadius: 10, // how blurry the shadow is
                      offset: Offset(0, 4), // shadow position: x, y
                    ),
                  ],
                ),
              ),
    );
  }
}