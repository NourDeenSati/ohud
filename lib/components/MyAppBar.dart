import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onClose;

  const MyAppBar({
    super.key,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false, // لإزالة زر الرجوع التلقائي
       
        actions: [
           Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // أو أي إجراء عند الضغط
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                radius: 18,
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
          Spacer(flex: 1,),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Spacer(flex: 2,),
         
        ],
        backgroundColor:Color(0XFFFBFBFB),
        elevation: 0,
        toolbarHeight: 80,);
      
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
