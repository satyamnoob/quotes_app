import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/controller/author_quotes_response_controller.dart';
import 'package:quotes_app/controller/sharedpref_controller.dart';
import 'package:quotes_app/models/quote.dart';
import 'package:quotes_app/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorQuoteView extends ConsumerStatefulWidget {
  const AuthorQuoteView({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthorQuoteView> createState() => _AuthorQuoteViewState();
}

class _AuthorQuoteViewState extends ConsumerState<AuthorQuoteView> {
  bool _quoteArrived = false;
  bool _errLoading = false;
  bool? _isLiked;

  late Quote quote;
  final TextEditingController _authorController = TextEditingController();
  final SharedPrefController sharedPrefController = SharedPrefController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> searchAuthorQuote() async {
    try {
      quote = ref.read(authorQuoteProvider.state).state ??
          await AuthorQuotesResponseController(
                  author: _authorController.text.trim())
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

  void _toggleSaveQuoteToFavorites() async {
    bool value = await sharedPrefController.contains(quote.id!);
    if (value) {
      await sharedPrefController.remove(quote.id!);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("like${quote.id!}", false);
      print(prefs.getBool("like${quote.id!}"));
    } else {
      Map data = quote.toJsonForSP();
      await sharedPrefController.save(quote.id!, data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("like${quote.id!}", true);
      print(prefs.getBool("like${quote.id!}"));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // print(_isLiked);
      _isLiked = prefs.getBool("like${quote.id!}");
    });
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
            ? Center(
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
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          controller: _authorController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Author",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          ref.watch(authorQuoteProvider.state).state = null;
                          searchAuthorQuote().whenComplete(
                              () => setState(() => _quoteArrived = true));
                        },
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
                    Positioned(
                      bottom: 10,
                      right: 5,
                      child: IconButton(
                        onPressed: () async {
                          _toggleSaveQuoteToFavorites();
                        },
                        icon: Icon(
                          (_isLiked == null || _isLiked == false)
                              ? const IconData(0xf440,
                                  fontFamily: 'MaterialIcons')
                              : const IconData(0xf0232,
                                  fontFamily: 'MaterialIcons'),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
