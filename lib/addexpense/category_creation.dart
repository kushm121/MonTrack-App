
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:expense_repo/expense_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/create_categorybloc/create_category_bloc.dart';


Future getcategorycreation(BuildContext context){
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
  return showDialog(
      context: context,
      builder: (ctx){
        bool isExpended = false;
        String iconSelected = '';
        Color categoryColor = Colors.grey.shade100;
        TextEditingController CategoryNameController = TextEditingController();
        bool isLoading = false;
        Category category = Category.empty;
        return BlocProvider.value(
          value: context.read<CreateCategoryBloc>(),
          child: StatefulBuilder(
            builder: (ctx,setState) {
            return BlocListener<CreateCategoryBloc,CreateCategoryState>(
              listener: (context,state){
                if(state is CreateCategorySuccess){
                  Navigator.pop(ctx);
                }
                else if(state is CreateCategoryLoading){
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: AlertDialog(
                title: Text(
                    "Create a Category"
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: CategoryNameController,
                          textAlignVertical: TextAlignVertical
                              .center,
                          decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintText: "Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none
                              )
                          ),
                        ),
                        SizedBox(height: 16,),
                        TextFormField(
                          // controller: CategoryNameController,
                          onTap: () {
                            setState(() {
                              isExpended = !isExpended;
                            });
                          },
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey[100],
                              hintText: "Icon",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  isExpended?
                                  BorderRadius.vertical(
                                      top: Radius.circular(12)
                                  )
                                      : BorderRadius.circular(12),
                                  borderSide: BorderSide.none
                              ),
                              suffixIcon: Icon(
                                  Icons.arrow_drop_down
                              )
                          ),
                        ),
                        isExpended ?
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius
                                  .vertical(
                                  bottom: Radius.circular(12)
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5
                                ),
                                itemCount: myCategoriesIcons.length,
                                itemBuilder: (context,int i){
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        iconSelected = myCategoriesIcons[i];
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 3,
                                              color: iconSelected == myCategoriesIcons[i]
                                                  ?Colors.green
                                                  :Colors.grey
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/${myCategoriesIcons[i]}.png',
                                              )
                                          )
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        )
                            : Container(),
                        SizedBox(height: 16,),
                        TextFormField(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorPicker(
                                          pickerColor: categoryColor,
                                          onColorChanged: (value) {
                                            setState(() {
                                              categoryColor = value;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx2);
                                              },
                                              style: TextButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                              child: const Text(
                                                'Save Color',
                                                style: TextStyle(fontSize: 22, color: Colors.white),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                          // controller: dateController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: categoryColor,
                              hintText: "Color",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none
                              )
                          ),
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: kToolbarHeight,
                          child: isLoading==true
                              ?const Center(
                            child: CircularProgressIndicator(),
                          )
                              :TextButton(
                              onPressed: (){
                                //create the category here
                                setState((){
                                  category.categoryId = Uuid().v1();
                                  category.name = CategoryNameController.text;
                                  category.color = categoryColor.value;
                                  category.icon = iconSelected;
                                });
                                context.read<CreateCategoryBloc>().add(CreateCategory(category));
                                // Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ) ,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
            }
          ),
        );
      }
  );
}
