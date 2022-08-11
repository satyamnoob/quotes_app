import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/controller/author_quotes_response_controller.dart';
import 'package:quotes_app/models/author_quote.dart';
import 'package:quotes_app/providers/auth_quote_provider.dart';

class AuthorQuoteView extends ConsumerStatefulWidget {
  const AuthorQuoteView({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthorQuoteView> createState() => _AuthorQuoteViewState();
}

class _AuthorQuoteViewState extends ConsumerState<AuthorQuoteView> {
  bool _quoteArrived = false;
  bool _errLoading = false;
  late AuthorQuote quote;
  @override
  void initState() {
    super.initState();
    initAsync().whenComplete(() => setState(() => _quoteArrived = true));
  }

  Future<void> initAsync() async {
    try {
      quote = ref.read(authQuoteProvider.state).state ??
          await AuthorQuotesResponseController(author: 'Rabindranath Tagore')
              .getAuthorQuoteResponse()
              .then((value) => ref.read(authQuoteProvider.state).state = value);
    } catch (e) {
      print(e.toString());
      setState(() => _errLoading = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _errLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.error, color: Colors.red, size: 28.0),
              SizedBox(width: 5.0),
              Text(
                "Something went wrong!",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          )
        : !_quoteArrived
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : Container(
                padding: const EdgeInsets.all(
                  10,
                ),
                margin: const EdgeInsets.only(top: 50),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/1.jpg"),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          quote.content!,
                          // 'Loading',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '- ${quote.author!}',
                          // 'loading',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }
}
