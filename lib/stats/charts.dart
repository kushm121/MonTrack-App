import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'ch.dart';



class StatsPage extends StatefulWidget{
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Statistics",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                  child: MyChart(),
                )
              )
            ],
          ),
        )
    );
  }
}
