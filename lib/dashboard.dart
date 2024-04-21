import 'dart:math';
import 'package:expense_repo/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'addexpense/expense_methods.dart';
import 'AllTransactions.dart';
import 'landing.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  String username = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getCurrentUsername(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            String username = snapshot.data!;
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/pbg.png"),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10),
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
                                    color: Color(0xFF6200EA)),
                                child: Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  FutureBuilder<String?>(
                                    future: getCurrentUsername(),
                                    // Fetch the username
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
                                        username = snapshot.data!;
                                        return Text(
                                          snapshot.data ?? 'N/A',
                                          // Display 'N/A' if username is null
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 178, 89, 252),
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
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LandingPage()),
                                );
                              },
                              child: Text("Logout",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 178, 89, 252),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14))),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFC54B8C),
                              Color(0xFF8A2BE2),
                              Color(0xFF4A148C),
                            ], transform: const GradientRotation(pi / 4)),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.deepPurpleAccent,
                                  offset: const Offset(5, 5))
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Balance",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            FutureBuilder<int>(
                              future: getTotalBalance(
                                  username), // Pass the user ID here
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                      color: Colors.white);
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                    '\$${snapshot.data?.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            // Text(
                            //   "45000.00",
                            //   style: TextStyle(
                            //       fontSize: 40,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            const SizedBox(
                              width: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.white30,
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.arrow_down,
                                            size: 12,
                                            color: Colors.greenAccent,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Income",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          FutureBuilder<int>(
                                            future: getTotalAmountInCategory(
                                                "Income",
                                                username), // Pass the user ID here
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator(
                                                    color: Colors.white);
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return Text(
                                                  '\$${snapshot.data?.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          // Text(
                                          //   "2300.00",
                                          //   style: TextStyle(
                                          //       fontSize: 16,
                                          //       color: Colors.white,
                                          //       fontWeight: FontWeight.w600),
                                          // ),
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
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.arrow_up,
                                            size: 12,
                                            color: Colors.greenAccent,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Expenses",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          FutureBuilder<int>(
                                            future: getTotalAmountExceptIncome(
                                                username), // Pass the user ID here
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator(
                                                    color: Colors.white);
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return Text(
                                                  '\$${snapshot.data?.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              }
                                            },
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
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transactions",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllTransactionsPage(
                                          username: username,
                                        )),
                              );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[100],
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<List<Expense>>(
                          future: getAllExpenses(username),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Expense>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              List<Expense> expenses = snapshot.data ?? [];
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: expenses.length < 4
                                        ? expenses.length
                                        : 4,
                                    itemBuilder: (context, int i) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  75, 98, 0, 234),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  expenses[i]
                                                                      .category
                                                                      .color),
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                        Image.asset(
                                                          'assets/images/${expenses[i].category.icon}.png',
                                                          scale: 2,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      expenses[i].Desc,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "\$${expenses[i].amount}.00",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                              'dd MMMM yyyy, hh:mm a')
                                                          .format(
                                                              expenses[i].date),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
