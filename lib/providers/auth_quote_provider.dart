import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/models/author_quote.dart';

class AuthQuoteProvider extends StateNotifier<AuthorQuote?> {
  AuthorQuote? quote;

  AuthQuoteProvider() : super(null);

  void addQuote(AuthorQuote? quote) {
    state = quote;
  }

  void deleteQuote() {
    state = null;
  }
}

final authQuoteProvider = StateNotifierProvider<AuthQuoteProvider, AuthorQuote?>(
  (ref) => AuthQuoteProvider(),
);
