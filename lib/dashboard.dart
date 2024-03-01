import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/pbg.png"), fit: BoxFit.cover),
          ),
          child: SafeArea(
              child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 340, child: _head()),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < 5) {
                    // Limiting to 5 transactions
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(150, 90, 28, 173),
                            Color.fromARGB(150, 25, 33, 98),
                            Color.fromARGB(150, 90, 28, 173),
                          ],
                          stops: [0.0, 0.5, 1],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child:
                              Image.asset('assets/images/cre.jpeg', height: 40),
                        ),
                        title: Text(
                          'Credit Card',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '12:00 PM',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          '\₹ 1200',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return null; // Returning null for items beyond the limit
                  }
                },
              ),
            )
          ])),
        ),
      ),
    );
  }
}

Widget _head() {
  return Stack(children: [
    Column(
      children: [
        Container(
            width: double.infinity,
            height: 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(150, 90, 28, 173),
                  Color.fromARGB(150, 25, 33, 98),
                  Color.fromARGB(150, 90, 28, 173),
                ],
                stops: [0.0, 0.5, 1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(children: [
              Positioned(
                top: 35,
                left: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    height: 40,
                    width: 40,
                    color: Color.fromRGBO(250, 250, 250, 0.1),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notification_add_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.userCircle,
                              size: 50,
                              color: Color.fromARGB(255, 178, 89, 252),
                            ),
                            SizedBox(
                              height: 10,
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
                      ),
                    ]),
              )
            ])), //add 2 brackets
      ],
    ),
    Positioned(
        top: 140,
        left: 50,
        child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 192, 115, 255),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 6),
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 142, 35, 237),
                  Color.fromARGB(255, 92, 4, 195),
                  Color.fromARGB(255, 142, 35, 237),
                ],
                stops: [0.0, 0.5, 1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Balance',
                          style: TextStyle(
                            color: Color.fromARGB(255, 224, 223, 223),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        )
                      ]),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '\₹ 12334',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 0, 255, 0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              color: Color.fromARGB(255, 216, 216, 216),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 255, 0, 0),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Expense',
                            style: TextStyle(
                              color: Color.fromARGB(255, 216, 216, 216),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\₹12000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\₹334',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )))
  ]);
}
