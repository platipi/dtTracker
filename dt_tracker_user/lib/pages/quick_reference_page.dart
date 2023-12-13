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
        if (curCred != null)
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              curCred = null;
              units = [];
              refreshParent();
            },
            child: Text('logout'),
          ),
        if (curCred == null)
          Expanded(
              child: Column(
            children: [
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
              TextButton(
                onPressed: () async {
                  curCred = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: 'email@email.com', password: 'password');
                  updateUser(refreshParent);
                },
                child: Text('quick login as email@email.com'),
              ),
              TextButton(
                onPressed: () async {
                  curCred = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: 'mbunn3@nait.ca', password: 'password');
                  updateUser(refreshParent);
                },
                child: Text('quick login as mbunn3@nait.ca'),
              ),
            ],
          )),
      ],
    ));
  }
}
