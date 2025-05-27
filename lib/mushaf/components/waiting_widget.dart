import 'package:flutter/material.dart';

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }
}
