import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quotes_app/controller/sharedpref_controller.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  SharedPrefController sharedPrefController = SharedPrefController();
  List<Quote> quotes = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Hello");
    for (String key in prefs.getKeys()) {
      if (prefs.get(key) == true) {
        var quoteKey = key.substring(4);
        var data = await sharedPrefController.read(quoteKey);
        print("$key $quoteKey $data");
        setState(() {
          quotes.add(Quote.fromJson(data, null));
        });
      }
    }
    // prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return quotes.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.yellowAccent,
            ),
          )
        : ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                child: ListTile(
                  leading: Text(
                    '${quotes[index].author!} - ',
                  ),
                  title: Text(
                    quotes[index].content!,
                    textAlign: TextAlign.end,
                  ),
                  contentPadding: const EdgeInsets.all(8),
                ),
              );
            },
          );
  }
}
