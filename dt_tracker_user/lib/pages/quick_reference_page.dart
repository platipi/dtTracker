import 'package:dt_tracker_user/pages/login_page.dart';
import 'package:dt_tracker_user/utilities/data/data_firebase_functions.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReferenceWidget extends StatelessWidget {
  Function refreshParent;
  ReferenceWidget(this.refreshParent);

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
                builder: (context) => LoginState(refreshParent),
              ),
            );
          },
          child: Text('login'),
        ),
        Text('refresh parent'),
        TextButton(
          onPressed: () async {
            curCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: 'email@email.com', password: 'password');
            updateUser(refreshParent);
          },
          child: Text('quick login'),
        ),
      ],
    ));
  }
}
