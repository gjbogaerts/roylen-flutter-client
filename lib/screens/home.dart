import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './ads_list.dart';
import './ad_create.dart';
import './ads_selection.dart';
import '../widgets/app_drawer.dart';
import '../widgets/search.dart';
import '../widgets/filter.dart';

import '../providers/ads.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
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
      {'page': AdsSelection(ReturnMode.Search), 'title': 'Zoek advertenties'},
      {
        'page': AdsSelection(ReturnMode.Filtered),
        'title': 'Filter advertenties'
      },
      {'page': AdsSelection(ReturnMode.Favorites), 'title': 'Je favorieten'},
      {'page': AdCreate(), 'title': 'Plaats advertentie'},
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context).settings.arguments != null) {
      var args = ModalRoute.of(context).settings.arguments as Map<String, int>;
      _selectedPageIndex = args['idx'];
      _selectPage(_selectedPageIndex);
    }
  }

  void setSearchTerm(String q) async {
    await Provider.of<Ads>(context).fetchAndSetSearchItems(q);
  }

  void setFilterElements(elements) {
    print('starting to filter');
  }

  void setFavoriteItems() async {
    await Provider.of<Ads>(context).fetchAndSetFavoriteItems();
  }

  void _selectPage(int idx) {
    switch (idx) {
      case 1:
        //search screen
        setState(() {
          _selectedPageIndex = 1;
        });
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Search(setSearchTerm);
          },
        );
        break;
      case 2:
        //filter screen
        setState(() {
          _selectedPageIndex = 2;
        });
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Filter(setFilterElements);
          },
        );
        break;
      case 3:
        // favorites screen
        setFavoriteItems();
        setState(() {
          _selectedPageIndex = 3;
        });
        break;
      default:
        setState(() {
          _selectedPageIndex = idx;
        });
        break;
    }
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
            title: Text('Advertenties'),
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
            icon: Icon(Icons.favorite),
            title: Text('Favorieten'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            title: Text('Plaatsen'),
          ),
        ],
      ),
    );
  }
}
