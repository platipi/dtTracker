import 'package:dt_tracker_user/utilities/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginState extends StatefulWidget {
  const LoginState({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginState> createState() => LoginWidget();
}

class LoginWidget extends State<LoginState> {
  GlobalKey formKey = GlobalKey();
  String emailAddress = '';
  String password = '';
  bool register = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //login form vvv
              Container(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email *',
                        ),
                        onChanged: (value) {
                          emailAddress = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a Email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          labelText: 'Password *',
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a Password';
                          }
                          return null;
                        },
                      ),
                      if (register)
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.password),
                            labelText: 'Confirm Password *',
                          ),
                          validator: (value) {
                            if (value != password) {
                              return 'Password is not the same';
                            }
                            return null;
                          },
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          String feedback = '';
                          if ((formKey.currentState! as FormState).validate()) {
                            try {
                              if (!register) {
                                curCred = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: emailAddress,
                                        password: password);
                                feedback = 'Logged In!';
                                Navigator.pop(context);
                              } else {
                                curCred = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: emailAddress,
                                  password: password,
                                );
                                feedback = 'Created Account!';
                                Navigator.pop(context);
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found' ||
                                  e.code == 'invalid-credential') {
                                setState(() {
                                  register = true;
                                });
                                feedback =
                                    'Confirm your password to make an account';
                              } else if (e.code == 'wrong-password') {
                                feedback = 'Invalid password';
                              } else if (e.code == 'weak-password') {
                                feedback = 'Weak password';
                              } else if (e.code == 'email-already-in-use') {
                                feedback = 'That account already exists';
                              } else {
                                feedback = 'Invalid password';
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(feedback)),
                            );
                          }
                        },
                        child: Text(register ? 'Register' : 'Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
