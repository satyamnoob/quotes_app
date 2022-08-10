import 'package:flutter/material.dart';

import 'author_quote_view.dart';
import 'favorite_view.dart';
import 'search_quote_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _pageIndex = 0;
  List<Widget> pages = [
    AuthorQuoteView(),
    SearchQuoteView(),
    FavoriteView(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes App'),
        centerTitle: true,
      ),
      body: pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0x00ffffff),
        selectedFontSize: 18,
        selectedIconTheme: const IconThemeData(
          color: Colors.amberAccent,
          size: 30,
        ),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _pageIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 15,
        ),
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Author Quote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Quote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
