import 'package:flutter/material.dart';
import './ads_list.dart';
import './ad_create.dart';
import './search.dart';
import './ad_filter.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {'page': AdsList(), 'title': 'Alle advertenties'},
      {'page': SearchScreen(), 'title': 'Zoek advertenties'},
      {'page': AdFilter(), 'title': 'Filter advertenties'},
      {'page': AdCreate(), 'title': 'Plaats advertentie'},
    ];
  }

  void _selectPage(int idx) {
    setState(() {
      _selectedPageIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.add_circle_outline),
            onTap: () {
              var idx = _pages
                  .indexWhere((elm) => elm['title'] == 'Plaats advertentie');
              _selectPage(idx);
              // Navigator.of(context).pushReplacementNamed(AdCreate.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).cardColor,
        unselectedItemColor: Theme.of(context).canvasColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_on),
            title: Text('Alle advertenties'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Zoeken'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            title: Text('Filter'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            title: Text('Plaats advertentie'),
          ),
        ],
      ),
    );
  }
}