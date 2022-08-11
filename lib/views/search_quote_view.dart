import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/search_quote_response_controller.dart';
import '../models/quote.dart';
import '../providers/providers.dart';

class SearchQuoteView extends ConsumerStatefulWidget {
  const SearchQuoteView({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchQuoteView> createState() => _SearchQuoteViewState();
}

class _SearchQuoteViewState extends ConsumerState<SearchQuoteView> {
  bool _quoteArrived = false;
  bool _errLoading = false;
  bool? _isLiked;

  late Quote quote;
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  Future<void> searchQuotesByQueryAndLimit() async {
    try {
      quote = ref.read(searchQuoteProvider.state).state ??
          await SearchQuotesResponseController(
                  query: _queryController.text.trim(),
                  limit: int.parse(_limitController.text.trim()))
              .getAuthorQuoteResponse()
              .then(
                  (value) => ref.read(authorQuoteProvider.state).state = value);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _isLiked = prefs.getBool("like${quote.id!}") ?? false;
      // prefs.clear();
    } catch (e) {
      print(e.toString());
      setState(() => _errLoading = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.yellowAccent,
            ),
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
              ),
              controller: _queryController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search Query",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.yellowAccent,
          ),
          width: MediaQuery.of(context).size.width - 50,
          height: 40,
          child: TextField(
            style: const TextStyle(
              color: Colors.black,
            ),
            controller: _limitController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Enter limit(1 - 100)",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
          ),
          onPressed: () async {
            searchQuotesByQueryAndLimit();
          },
          child: const Text(
            'Search',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
