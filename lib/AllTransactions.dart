import 'dart:ui';
import 'SignUp.dart';
import 'Login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_repo/expense_repository.dart';
import 'dart:math';
import 'package:expense_repo/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'addexpense/expense_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_repo/expense_repository.dart';

class AllTransactionsPage extends StatefulWidget {
  final String username;

  const AllTransactionsPage({Key? key, required this.username})
      : super(key: key);

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  late Future<List<Expense>> _futureExpenses;

  @override
  void initState() {
    super.initState();
    _futureExpenses =
        getAllExpenses(widget.username); // Fetch all expenses for current user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 66, 1, 130),
                Color.fromARGB(255, 102, 0, 192)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'All Transactions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Expense>>(
          future: _futureExpenses,
          builder:
              (BuildContext context, AsyncSnapshot<List<Expense>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<Expense> expenses = snapshot.data ?? [];
              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  Expense expense = expenses[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(expense.category.color),
                        child: Image.asset(
                          'assets/images/${expense.category.icon}.png',
                          scale: 2,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        expense.Desc,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '\$${expense.amount}.00',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        DateFormat('dd MMMM yyyy, hh:mm a')
                            .format(expense.date),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
