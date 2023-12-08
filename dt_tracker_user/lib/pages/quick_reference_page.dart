import 'package:dt_tracker_user/pages/login_page.dart';
import 'package:flutter/material.dart';

class ReferenceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginState(),
                ),
              );
            },
            child: Text('login')),
        Text('quick reference'),
      ],
    ));
  }
}
