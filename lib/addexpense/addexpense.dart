import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:expense_repo/expense_repository.dart';
import 'package:uuid/uuid.dart';
import 'bloc/create_expense_bloc/create_expense_bloc.dart';
import 'bloc/get_category_bloc/get_categories_bloc.dart';
import 'category_creation.dart';


class AddExpense extends StatefulWidget {
  final String? username;
  const AddExpense(this.username, {super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController DescController = TextEditingController();
  // DateTime selectDate = DateTime.now();
  late Expense expense;

  bool isLoading = false;
  List<String>myCategoriesIcons = [
    "entertainment",
    "food",
    "home",
    "pet",
    "shopping",
    "tech",
    "travel",
    "income"
  ];


  @override
   void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = Uuid().v1();
    // expense.username = widget.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc,CreateExpenseState>(
      listener: (context,state){
        if(state is CreateExpenseSuccess){
          Navigator.pop(context);
        }
        else if(state is CreateExpenseLoading){
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
          ),
          body: BlocBuilder<GetCategoriesBloc,GetCategoriesState>(
            builder: (context,state) {
              if(state is GetCategoriesSuccess) {
                return Stack(
                  children:[ Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/pbg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
              ),SingleChildScrollView(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Add Expense",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(height: 16,),
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.7,
                                child: TextFormField(
                                  controller: expenseController,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      prefixIcon: Icon(
                                        CupertinoIcons.money_dollar,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      hintText: 'Enter an Amount',
                                      hintStyle: TextStyle(
                                          color: Colors.white
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 3
                                          )
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(height: 32,),
                              TextFormField(
                                controller: DescController,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(
                                      CupertinoIcons.pen,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Description',
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 3
                                        )
                                    )
                                ),
                              ),
                              SizedBox(height: 32,),
                              TextFormField(
                                controller: categoryController,
                                textAlignVertical: TextAlignVertical.center,
                                readOnly: true,
                                onTap: () {},
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: expense.category==Category.empty
                                    ?Colors.transparent
                                    :Color(expense.category.color),
                                    prefixIcon: expense.category==Category.empty
                                    ?Icon(
                                      CupertinoIcons.list_bullet,
                                      size: 30,
                                      color: Colors.white,
                                    ):Image.asset(
                                      'assets/images/${expense.category.icon}.png',
                                      scale: 2,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          var newCategory = await getcategorycreation(context);
                                          setState(() {
                                            state.categories.insert(0, newCategory);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          size: 26,
                                          color: Colors.grey,
                                        )
                                    ),
                                    hintText: "Category",
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.white
                                        )
                                    )
                                ),
                              ),
                              Container(
                                height: 200,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:ListView.builder(
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, int i) {
                                      return Card(
                                        child: ListTile(
                                          onTap: () {
                                            setState(() {
                                              expense.category = state.categories[i];
                                              categoryController.text = expense.category.name;
                                            });
                                          },
                                          leading: Image.asset(
                                            'assets/images/${state.categories[i].icon}.png',
                                            scale: 2,
                                          ),
                                          title: Text(state.categories[i].name),
                                          tileColor: Color(
                                              state.categories[i].color),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        ),
                                      );
                                    }
                                )
                                )
                              ),
                              const SizedBox(height: 16,),
                              TextFormField(
                                controller: dateController,
                                textAlignVertical: TextAlignVertical.center,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: expense.date,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365))
                                  );
                                  if (newDate != null) {
                                    setState(() {
                                      dateController.text =
                                          DateFormat('dd/MM/yyyy').format(newDate);
                                      // selectDate = newDate;
                                      expense.date = newDate;
                                    });
                                  }
                                },
                                style: TextStyle(
                                    color: Colors.white
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    prefixIcon: Icon(
                                      Icons.date_range,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    hintText: "Date",
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.white
                                        )
                                    )
                                ),
                              ),
                              const SizedBox(height: 32,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: kToolbarHeight,
                                child:
                                isLoading==true ?
                                const Center(
                                  child: CircularProgressIndicator(),
                                )
                                :Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 66, 1, 130),
                                        Color.fromARGB(255, 102, 0, 192)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          expense.username = widget.username!;
                                          expense.amount = int.parse(expenseController.text);
                                          expense.Desc = DescController.text;
                                        });
                                        context.read<CreateExpenseBloc>().add(CreateExpense(expense));
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)
                                          )
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                        ]
                );
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}