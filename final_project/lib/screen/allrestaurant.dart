import 'package:final_project/screen/logout.dart';
import 'package:final_project/screen/mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'formscreen.dart';
import 'home.dart';

class AllRestaurantScreen extends StatefulWidget {
  @override
  State<AllRestaurantScreen> createState() => _AllRestaurantScreenState();
}

class _AllRestaurantScreenState extends State<AllRestaurantScreen> {
  double userlong = 0;
  double userlat = 0;
  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      userlong = position.longitude;
      userlat = position.latitude;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FormScreen();
                }));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("restaurants").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(document["name"] +
                        "   Contract: " +
                        document["contract"]),
                    subtitle: Text(
                      document["description"],
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      getLocation();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            userLongitude: userlong,
                            userLatitude: userlat,
                            resLongitude:
                                double.parse(document['resLongitude']),
                            resLatitude: double.parse(document['resLatitude']),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            auth.signOut().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LogoutScreen();
              }));
            });
          },
          child: Icon(Icons.logout)),
    );
  }
}
