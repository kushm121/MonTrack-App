import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:montrack_app/addexpense/expense_methods.dart';
import 'package:montrack_app/dashboard.dart';
import 'package:montrack_app/stats/charts.dart';
import 'addexpense/addexpense.dart';
import 'addexpense/bloc/create_categorybloc/create_category_bloc.dart';
import 'addexpense/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'addexpense/bloc/get_category_bloc/get_categories_bloc.dart';
import 'package:expense_repo/expense_repository.dart';
import 'bloc/get_expenses_bloc/get_expense_bloc.dart';



class Bottom extends StatefulWidget {
  const Bottom({super.key});
  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom>{
  int index_color = 0;
  List Screen = [
    const dashboard(),
    const StatsPage(),
    BlocProvider(
        create: (context) =>GetExpensesBloc(FirebaseExpenseRepo())..add(GetExpenses()),
        child: const dashboard()
    ),
    const dashboard(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          String? username = await getCurrentUsername();
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context)=> MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CreateCategoryBloc(FirebaseExpenseRepo()),
                  ),
                  BlocProvider(
                    create: (context) => GetCategoriesBloc(FirebaseExpenseRepo())..add(GetCategories()),
                  ),
                  BlocProvider(
                    create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                  ),
                ],
                child: AddExpense(username!),
              ),
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 178, 89, 252),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 0, 9, 80),
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.only(top:7.5, bottom: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildIconButton(Icons.home, 0),
                buildIconButton(Icons.bar_chart_outlined, 1),
                const SizedBox(width: 20),
                buildIconButton(Icons.wallet_outlined, 2),
                buildIconButton(Icons.person_outline, 3),
              ],
            ),
          )
      ),
    );
  }
  IconButton buildIconButton(IconData icon, int index){
    return IconButton(
      onPressed: (){
        setState(() {
          index_color = index;
        });
      },
      icon: Icon(
        icon,
        size: 30,
        color: index_color == index ? Color.fromARGB(255, 178, 89, 252) : Colors.grey,
      ),
    );
  }
}

