import 'package:flutter/material.dart';
import 'package:montrack_app/dashboard.dart';
import 'bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/data.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getCurrentUsername() async {
  // Get the currently logged-in user
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Get the email of the logged-in user
    String email = user.email ??
        ''; // Email should not be null, but it's better to handle null case

    // Query Firestore to find the user document with the logged-in user's email
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('newUsers')
        .where('email', isEqualTo: email)
        .get();

    // Check if a user document with the logged-in user's email exists
    if (snapshot.size > 0) {
      // Get the first document (assuming there's only one user with the same email)
      Map<String, dynamic> userData = snapshot.docs[0].data();

      // Retrieve and return the username from the user data
      return userData['username'];
    } else {
      // Return null if no user document with the logged-in user's email is found
      return null;
    }
  } else {
    // Return null if no user is currently logged in
    return null;
  }
}

Future<String?> getCurrentUserEmail() async {
  // Get the currently logged-in user
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Get the email of the logged-in user
    String email = user.email ??
        ''; // Email should not be null, but it's better to handle null case

    // Query Firestore to find the user document with the logged-in user's email
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('newUsers')
        .where('email', isEqualTo: email)
        .get();

    // Check if a user document with the logged-in user's email exists
    if (snapshot.size > 0) {
      // Get the first document (assuming there's only one user with the same email)
      Map<String, dynamic> userData = snapshot.docs[0].data();

      // Retrieve and return the email from the user data
      return userData['email'];
    } else {
      // Return null if no user document with the logged-in user's email is found
      return null;
    }
  } else {
    // Return null if no user is currently logged in
    return null;
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/pbg.png"),
                    fit: BoxFit.cover)),
            child: ListView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Your Account',
                        style: TextStyle(
                          color: Color.fromARGB(255, 178, 89, 252),
                          fontFamily: 'Circular',
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.15,
                        height: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(200, 197, 75, 140),
                              Color.fromARGB(200, 138, 43, 226),
                              Color.fromARGB(200, 74, 20, 140),
                            ], transform: const GradientRotation(pi / 4)),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: []),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned(
                              child: Image(
                                  alignment: Alignment.topCenter,
                                  height: 150,
                                  width: 150,
                                  image: AssetImage("assets/images/pfp.png")),
                            ),
                            Positioned(
                              top: 80,
                              child: FutureBuilder<String?>(
                                future:
                                    getCurrentUsername(), // Fetch the username
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator while waiting for the username
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    // Display an error message if an error occurred
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Display the fetched username
                                    return Text(
                                      snapshot.data ??
                                          'N/A', // Display 'N/A' if username is null
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              top: 120,
                              child: Container(
                                height: 45,
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Profile()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Edit Your Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Circular',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Center(
                          child: FutureBuilder<String?>(
                            future: getCurrentUsername(), // Fetch the username
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Display a loading indicator while waiting for the username
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // Display an error message if an error occurred
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // Display the fetched username
                                return Text(
                                  'Username: ${snapshot.data ?? "N/A"}', // Display 'N/A' if username is null
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Circular',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Center(
                          child: FutureBuilder<String?>(
                            future: getCurrentUserEmail(), // Fetch the email
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Display a loading indicator while waiting for the email
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // Display an error message if an error occurred
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // Display the fetched email
                                return Text(
                                  'Email: ${snapshot.data ?? "N/A"}', // Display 'N/A' if email is null
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Circular',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Center(
                          child: Text(
                            'Phone No: 9876543210',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Center(
                          child: Text(
                            'Gender: Male',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
