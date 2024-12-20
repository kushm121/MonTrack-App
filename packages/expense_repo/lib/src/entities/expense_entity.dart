import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repo/src/entities/entities.dart';

import '../models/models.dart';

class ExpenseEntity {
  String username;
  String expenseId;
  Category category;
  DateTime date;
  int amount;
  String Desc;

  ExpenseEntity({
    required this.username,
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.Desc
  });

  Map<String, Object?> toDocument() {
    return {
      'username':username,
      'expenseId': expenseId,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'desc' : Desc
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      username: doc['username'],
      expenseId: doc['expenseId'],
      category: Category.fromEntity(CategoryEntity.fromDocument(doc['category'])),
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
      Desc: doc['desc']
    );
  }
}