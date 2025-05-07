import 'package:flutter/material.dart';

class Mystudentinfo2 extends StatelessWidget {
   Mystudentinfo2({super.key, required this.type, required this.info, required this.color});

 final String type ;
 final String info ; 
  final Color color ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
                height: 60,
        width: MediaQuery.of(context).size.width/6,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(type,style: TextStyle(fontSize: 12),), Text(info,style: TextStyle(color: color,fontSize: 12),)],
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