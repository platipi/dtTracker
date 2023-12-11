import 'package:dt_tracker_user/pages/login_page.dart';
import 'package:dt_tracker_user/utilities/globals.dart';
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
          onPressed: () {
            refreshParent();
            print(units);
          },
          child: Text('refresh'),
        ),
      ],
    ));
  }
}
