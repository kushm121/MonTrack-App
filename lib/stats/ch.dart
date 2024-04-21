import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repo/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<categoryData>> getCategoryWiseExpenditure(String username) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance.collection('expenses')
        .where('username', isEqualTo: username)
        .get();

    // Map to store category-wise expenditure
    Map<String, int> categoryExpenditure = {};

    querySnapshot.docs.forEach((doc) {
      String categoryName = doc['category']['name'];
      int amount = doc['amount'] as int;

      // Add the amount to the category's expenditure if it exists
      categoryExpenditure.update(categoryName, (value) => value + amount,
          ifAbsent: () => amount);
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

