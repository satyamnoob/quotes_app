import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quotes_app/models/author_quote.dart';

class AuthorQuotesResponseController {
  String author;

  AuthorQuotesResponseController({
    required this.author,
  });

  Future<AuthorQuote> getAuthorQuoteResponse() async {
    List<String> authorNames = author.trim().split(" ");
    var url = Uri.parse(
        "https://quotable.io/quotes?author=${authorNames[0]}-${authorNames[1]}");
    final response = await http.get(url);
    Map<String, dynamic> data = json.decode(response.body);
    if(response.statusCode == 200) {
      return AuthorQuote.fromJson(data, data['count']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
