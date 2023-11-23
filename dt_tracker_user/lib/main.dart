import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utilities/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

//chevron_compact_down for mook
//person for unit

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase database = FirebaseDatabase.instance;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
