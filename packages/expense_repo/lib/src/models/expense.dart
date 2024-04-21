import 'package:expense_repo/expense_repository.dart';

class Expense {
  String username;
  String expenseId;
  Category category;
  DateTime date;
  int amount;
  String Desc;

  Expense({
    required this.username,
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.Desc
  });

  static final empty = Expense(
    username: '',
    expenseId: '',
    category: Category.empty,
    date: DateTime.now(),
    amount: 0,
    Desc: ''
  );

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      username: username,
      expenseId: expenseId,
      category: category,
      date: date,
      amount: amount,
      Desc : Desc
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      username: entity.username,
      expenseId: entity.expenseId,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      Desc : entity.Desc
    );
  }
}