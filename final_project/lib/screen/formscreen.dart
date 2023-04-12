import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';

import '../model/restaurant.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Restaurant myRestaurant = Restaurant();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _restaurantCollection =
      FirebaseFirestore.instance.collection("restaurants");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD RESTAURANT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Restaurant Name'),
                    TextFormField(
                      validator: RequiredValidator(errorText: 'Require name'),
                      onSaved: (String? name) {
                        myRestaurant.name = name;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Description'),
                    TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Require Description')
                      ]),
                      onSaved: (String? description) {
                        myRestaurant.description = description;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Contract'),
                    TextFormField(
                      validator: MultiValidator(
                          [RequiredValidator(errorText: 'Require Contract')]),
                      onSaved: (String? contract) {
                        myRestaurant.contract = contract;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Longitude'),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator:
                          RequiredValidator(errorText: 'Require Longitude'),
                      onSaved: (String? resLongitude) {
                        myRestaurant.resLongitude = resLongitude;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text('Latitude'),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator:
                          RequiredValidator(errorText: 'Require Latitude'),
                      onSaved: (String? resLatitude) {
                        myRestaurant.resLatitude = resLatitude;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              await _restaurantCollection.add({
                                "name": myRestaurant.name,
                                "description": myRestaurant.description,
                                "contract": myRestaurant.contract,
                                "resLongitude": myRestaurant.resLongitude,
                                "resLatitude": myRestaurant.resLatitude
                              });

                              formKey.currentState!.reset();
                              Navigator.pop(context);
                            }
                          },
                          child: Text('ADD Restaurant')),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
