import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/models/author_quote.dart';

final StateProvider authQuoteProvider = StateProvider<AuthorQuote?>((ref) => null);
