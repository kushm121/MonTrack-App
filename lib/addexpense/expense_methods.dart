import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repo/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

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


Future<int> getTotalAmountInCategory(String categoryName) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
    // .where('userId', isEqualTo: userId)
        .where('category.name', isEqualTo: categoryName)
        .get();

    int totalAmount = 0;

    querySnapshot.docs.forEach((doc) {
      totalAmount += doc['amount'] as int;
    });

    return totalAmount;
  } catch (e) {
    print('Error getting total amount in $categoryName category: $e');
    rethrow;
  }
}


Future<int> getTotalAmountExceptIncome() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
    // .where('userId', isEqualTo: userId)
        .get();

    int totalAmount = 0;

    querySnapshot.docs.forEach((doc) {
      String categoryName = doc['category']['name'];
      int amount = doc['amount'] as int;

      if (categoryName != 'Income') {
        totalAmount += amount;
      }
    });

    return totalAmount;
  } catch (e) {
    print('Error getting total amount except for income: $e');
    rethrow;
  }
}


Future<List<Expense>> getAllExpenses() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
        .orderBy('date', descending: true).get();
    return querySnapshot.docs.map((doc) {
      return Expense(
        username: doc['username'],
        expenseId: doc['expenseId'],
        category: Category.fromEntity(CategoryEntity.fromDocument(doc['category'])),
        date: (doc['date'] as Timestamp).toDate(),
        amount: doc['amount'],
        Desc: doc['desc'],
      );
    }).toList();
  } catch (e) {
    print('Error getting expenses: $e');
    rethrow;
  }
}

Future<int> getTotalBalance() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
    // .where('userId', isEqualTo: userId)
        .get();

    int totalAmount = 0;
    int incomeAmount = 0;

    querySnapshot.docs.forEach((doc) {
      String categoryName = doc['category']['name'];
      int amount = doc['amount'] as int;

      if (categoryName == 'Income') {
        incomeAmount += amount;
      } else {
        totalAmount += amount;
      }
    });

    return - totalAmount + incomeAmount;
  } catch (e) {
    print('Error getting total balance: $e');
    rethrow;
  }
}