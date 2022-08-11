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
  late AuthorQuote? quote = AuthorQuote();
  late final provider = AuthQuoteProvider();
  @override
  void initState() {
    super.initState();
    if (!_quoteArrived) {
      initAsync();
    }
  }

  void initAsync() async {
    quote = await AuthorQuotesResponseController(author: 'Rabindranath Tagore')
        .getAuthorQuoteResponse();
    final q = ref.watch(authQuoteProvider);
    provider.addQuote(
      AuthorQuote(author: quote!.author, content: quote!.content),
    );
    print(q);
    setState(() {
      _quoteArrived = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth - 40;
        return (!_quoteArrived)
            ? Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  width: maxWidth,
                  height: 50,
                  child: Row(
                    children: [
                      const Flexible(
                        flex: 1,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Author",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        splashRadius: 1,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
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
                          quote!.content!,
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
                          '- ${quote!.author!}',
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
      },
    );
  }
}
