import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:montrack_app/stats/ch.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Profile.dart';
class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late List<GDPdata> _chartdata;

  @override
  void initState() {
    _chartdata = getchartdata();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getCurrentUsername(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          else {
            String username = snapshot.data!;
            return SafeArea(
              child: Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/pbg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // SizedBox(height: 20),
                            Text(
                              "Statistics",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            SizedBox(height: 20,),
                            FutureBuilder(
                              future: getCategoryWiseExpenditure(username),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }
                                else {
                                  List<categoryData>? chartdata1 = snapshot.data;
                                  return Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          12, 20, 12, 12),
                                      child: SfCartesianChart(
                                        backgroundColor: Colors.transparent,

                                        series: [
                                          ColumnSeries<categoryData, String>(
                                            dataSource: chartdata1,
                                            xValueMapper: (categoryData data,
                                                _) =>
                                            data.category,
                                            yValueMapper: (categoryData data,
                                                _) =>
                                            data.amount,
                                            dataLabelSettings: DataLabelSettings(
                                                isVisible: true,
                                                labelAlignment:
                                                ChartDataLabelAlignment.top,
                                                textStyle: TextStyle(
                                                  color: Colors.white
                                                )
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 66, 1, 130),
                                                Color.fromARGB(255, 102, 0, 192),
                                                Color.fromARGB(255, 178, 89, 252)
                                              ]
                                            ),
                                            borderRadius: BorderRadius.circular(30),
                                          )
                                        ],
                                        primaryYAxis: NumericAxis(
                                          majorGridLines: MajorGridLines(
                                              width: 0
                                          ),
                                          axisLine: AxisLine(
                                            // color: Colors.white
                                              width: 0
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                        primaryXAxis: CategoryAxis(
                                          majorGridLines: MajorGridLines(
                                            width: 0
                                          ),
                                          axisLine: AxisLine(
                                            // color: Colors.white
                                            width: 0
                                          ),
                                          labelStyle: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },

                            ),
                            SizedBox(height: 20),
                            GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                buildCard("Card 1"),
                                buildCard("Card 2"),
                                buildCard("Card 3"),
                                buildCard("Card 4"),
                                buildCard("Card 5"),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                                child: SfCartesianChart(
                                  series: [
                                    BarSeries<GDPdata, String>(
                                      dataSource: _chartdata,
                                      xValueMapper: (GDPdata gdp, _) =>
                                      gdp.continent,
                                      yValueMapper: (GDPdata gdp, _) => gdp.gdp,
                                    )
                                  ],
                                  primaryXAxis: CategoryAxis(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
    );
  }

  Widget buildCard(String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

List<GDPdata> getchartdata(){
  final List<GDPdata>chartdata = [
    GDPdata('oceania', 1600),
    GDPdata('Africa', 2400),
    GDPdata('s america', 2900),
    GDPdata('Europe', 23050),
    GDPdata('asia', 34950),
  ];
  return chartdata;
}
class GDPdata{
  GDPdata(this.continent,this.gdp);
  final String continent;
  final double gdp;
}