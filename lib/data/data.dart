import 'package:flutter/material.dart';
//example data h
List<Map<String, dynamic>> transactionData = [
  {
    'icon': const Icon(Icons.food_bank_outlined,color: Colors.white,),
    'color': Colors.yellow[700],
    'name': 'Food',
    'amount': '-56.00',
    'date': 'Today'
  },
  {
    'icon': const Icon(Icons.shopping_bag,color: Colors.white),
    'color': Colors.purple[700],
    'name': 'Shopping',
    'amount': '-236.00',
    'date': 'Today'
  },
  {
    'icon': const Icon(Icons.car_rental,color: Colors.white),
    'color': Colors.red[700],
    'name': 'Uber',
    'amount': '-180.00',
    'date': 'Today'
  },
  {
    'icon': const Icon(Icons.soap,color: Colors.white),
    'color': Colors.blue[700],
    'name': 'Soap',
    'amount': '-80.00',
    'date': 'Today'
  }
];