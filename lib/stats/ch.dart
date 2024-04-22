import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repo/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<categoryData>> getCategoryWiseExpenditure(String username) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
        .where('username', isEqualTo: username)
        .get();
    Map<String, int> categoryExpenditure = {};
    querySnapshot.docs.forEach((doc) {
      String categoryName = doc['category']['name'];
      int amount = doc['amount'] as int;

      // Add the amount to the category's expenditure if it exists
      if(categoryName!= 'Income') {
        categoryExpenditure.update(categoryName, (value) => value + amount,
            ifAbsent: () => amount);
      }
    });
    List<categoryData> categoryDataList = categoryExpenditure.entries
        .map((entry) => categoryData(entry.key, entry.value))
        .toList();

    return categoryDataList;
  } catch (e) {
    print('Error getting category-wise expenditure: $e');
    rethrow;
  }
}

class categoryData {
  categoryData(this.category, this.amount);

  final String category;
  final int amount;
}


Future<Map<String, int>> getCurrentMonthData(String username) async {
  try {
    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end dates of the current month
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime(now.year, now.month + 1, 0);

    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
        .where('username', isEqualTo: username)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    // Map to store category-wise expenditure
    Map<String, int> categoryExpenditure = {};
    int totalIncome = 0;
    int totalExpenses = 0;
    querySnapshot.docs.forEach((doc) {
      String categoryName = doc['category']['name'];
      int amount = doc['amount'] as int;
      if(categoryName == 'Income'){
        totalIncome+=amount;
      }
      else{
        totalExpenses+=amount;
      }
    });

    int savings = totalIncome - totalExpenses;

    return {
      'Expenses': totalExpenses,
      'Income': totalIncome,
      'Savings': savings,
    };
  } catch (e) {
    print('Error getting current month data: $e');
    rethrow;
  }
}


Future<Map<DateTime, int>> getLast7DaysExpenses(String username) async {
  try {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 6));
    Map<DateTime, int> expensesMap = {};

    for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      DateTime nextDate = date.add(Duration(days: 1));
      var expenseSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('username', isEqualTo: username)
          .where('date', isGreaterThanOrEqualTo: date)
          .where('date', isLessThan: nextDate)
          .get();

      int totalExpenses = 0;

      expenseSnapshot.docs.forEach((doc) {
        String categoryName = doc['category']['name'];
        int amount = doc['amount'] as int;
        if(categoryName != 'Income'){
          totalExpenses+=amount;
        }
      });

      expensesMap[date] = totalExpenses;
    }

    return expensesMap;
  } catch (e) {
    print('Error getting last 7 days expenses: $e');
    rethrow;
  }
}


