import 'package:flutter/material.dart';

class SearchQuoteView extends StatefulWidget {
  const SearchQuoteView({Key? key}) : super(key: key);

  @override
  State<SearchQuoteView> createState() => _SearchQuoteViewState();
}

class _SearchQuoteViewState extends State<SearchQuoteView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Search Quote View"),
    );
  }
}