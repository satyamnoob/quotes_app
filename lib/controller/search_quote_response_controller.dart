import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quotes_app/models/quote.dart';

class SearchQuotesResponseController {
  String query;
  int limit;

  SearchQuotesResponseController({
    required this.query,
    required this.limit,
  });

  Future<Quote> getAuthorQuoteResponse() async {
    var url = Uri.parse(
        "https://quotable.io/quotes?author=$query&limit=$limit");
    final response = await http.get(url);
    Map<String, dynamic> data = json.decode(response.body);
    if(response.statusCode == 200) {
      return Quote.fromJson(data, data['count']);
    } else {
      throw Exception('Failed to load');
    }
  }
}