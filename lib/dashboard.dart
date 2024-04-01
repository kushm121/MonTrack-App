import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/data.dart';
import 'landing.dart';
import 'SignUp.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to fetch current user's username
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

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/pbg.png"), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6200EA)
                        ),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          ),
                          FutureBuilder<String?>(
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
                                    color: Color.fromARGB(255, 178, 89, 252),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(
                      CupertinoIcons.settings,
                      color: Colors.white,
                    )
                  )
                ],
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFFC54B8C),
                          Color(0xFF8A2BE2),
                          Color(0xFF4A148C),
                        ],
                        transform: const GradientRotation(pi/4)
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.deepPurpleAccent,
                          offset: const Offset(5,5)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    SizedBox(height: 12,),
                    Text(
                      "45000.00",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.arrow_down,
                                    size: 12,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Income",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    "2300.00",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.arrow_up,
                                    size: 12,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Expenses",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Text(
                                    "2300.00",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transactions",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      "View All",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[100],
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                    itemCount: transactionData.length,
                    itemBuilder: (context, int i){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF6200EA),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: transactionData[i]['color'],
                                              shape: BoxShape.circle
                                          ),
                                        ),
                                        transactionData[i]['icon']
                                      ],
                                    ),
                                    SizedBox(width: 12,),
                                    Text(
                                      transactionData[i]['name'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      transactionData[i]['amount'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    Text(
                                      transactionData[i]['date'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


