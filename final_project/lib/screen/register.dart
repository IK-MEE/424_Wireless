import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/profile.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: Text("Create Account")),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email'),
                          TextFormField(
                            validator: MultiValidator([
                              EmailValidator(errorText: "**REQUIRE EMAIL**"),
                              RequiredValidator(errorText: "**REQUIRE EMAIL**")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email!;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Password'),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "**REQUIRE PASSWORD**"),
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password!;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      try {
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: profile.email,
                                                password: profile.password)
                                            .then((value) {
                                          formKey.currentState!.reset();
                                          Fluttertoast.showToast(
                                            msg: 'Create  Account already',
                                            gravity: ToastGravity.CENTER,
                                          );
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return HomeScreen();
                                          }));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        // print(e.code);
                                        // print(e.message);
                                        Fluttertoast.showToast(
                                          msg: 'Error: ${e.code}',
                                          gravity: ToastGravity.CENTER,
                                        );
                                      }
                                    }
                                  },
                                  child: Text("Create Account")))
                        ],
                      )),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));
                  },
                  child: Icon(Icons.arrow_back)),
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('ERROR'),
              ),
              body: Center(child: Text("${snapshot.error}")),
            );
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
