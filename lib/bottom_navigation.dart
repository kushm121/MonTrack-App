import 'package:flutter/material.dart';
import 'package:montrack_app/dashboard.dart';
import 'package:montrack_app/landing.dart';
import 'package:montrack_app/Profile.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;
  List Screen = [
    const dashboard(),
    const LandingPage(), //will be changed when more pages are there
    const dashboard(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute<void>(
          //       builder: (BuildContext context)=> const AddExpense()
          //   ),
          // );
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
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
          )),
    );
  }

  IconButton buildIconButton(IconData icon, int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          index_color = index;
        });
      },
      icon: Icon(
        icon,
        size: 30,
        color: index_color == index ? Colors.blue : Colors.grey,
      ),
    );
  }
}
