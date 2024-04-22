import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StocksPage extends StatefulWidget {
  const StocksPage({Key? key}) : super(key: key);

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  late Map<String, dynamic> stockData = {};
  late List<String> failedStocks = [];

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    final List<String> symbols = ['MSFT', 'GOOGL', 'NVDA', 'AAPL', 'AMZN'];
    final String apiKey = '82X8LJTKJ9UN7H2Y';
    final String baseUrl = 'https://www.alphavantage.co/query';

    for (String symbol in symbols) {
      final Uri uri = Uri.parse(
          '$baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey');

      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          stockData[symbol] = jsonDecode(response.body);
        });
      } else {
        // Handle error
        print('Failed to fetch data for $symbol');
        failedStocks.add(symbol);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pbg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Stocks Information",
                      style: TextStyle(
                        color: Color.fromARGB(255, 178, 89, 252),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Display stock information or error message
                    if (failedStocks.isNotEmpty)
                      Text(
                        'Failed to fetch data for: ${failedStocks.join(', ')}',
                        style: TextStyle(color: Colors.red),
                      ),
                    for (String symbol in stockData.keys)
                      Card(
                        color: Color.fromARGB(150, 38, 31, 143),
                        child: ListTile(
                          title: Text(
                            symbol,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: stockData[symbol] != null
                              ? Text(
                                  'Price: \$${stockData[symbol]['Global Quote']['05. price']}',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  'Data not available',
                                  style: TextStyle(color: Colors.white),
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