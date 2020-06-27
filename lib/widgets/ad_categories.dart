import 'package:flutter/material.dart';
import '../models/cats.dart';

class AdCategories extends StatefulWidget {
  final Function _callbackMainCats;
  final Function _callbackSubCats;
  final Function _callbackSubSubCats;
  final String existingMainCat;
  final String existingSubCat;
  final String existingSubSubCat;

  AdCategories(
    this._callbackMainCats,
    this._callbackSubCats,
    this._callbackSubSubCats, {
    this.existingMainCat,
    this.existingSubCat,
    this.existingSubSubCat,
  });

  @override
  _AdCategoriesState createState() => _AdCategoriesState();
}

class _AdCategoriesState extends State<AdCategories> {
  String _mainCat;
  String _subCat;
  String _subSubCat;
  List<String> _subCatsList;
  List<String> _subSubCatsList;

  @override
  void initState() {
    super.initState();
    _mainCat = widget.existingMainCat ?? null;
    _subCat = widget.existingSubCat ?? null;
    _subSubCat = widget.existingSubSubCat ?? null;
    if (_mainCat != null) {
      _subCatsList = Cats.getSubCategories(_mainCat);
      _buildSubItems();
    }
    if (_subCat != null) {
      _subSubCatsList = Cats.getSubSubCategories(_mainCat, _subCat);
      _buildSubSubItems();
    }
  }

  List<DropdownMenuItem<String>> _buildList(List<String> items) {
    if (items == null) {
      return [];
    }
    return items
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList();
  }

  List<Widget> _buildItems() {
    var _mainCatsList = Cats.mainCategoriesOnly;
    return _buildList(_mainCatsList);
  }

  List<Widget> _buildSubItems() {
    return _buildList(_subCatsList);
  }

  List<Widget> _buildSubSubItems() {
    return _buildList(_subSubCatsList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButton<String>(
            value: _mainCat,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down_circle),
            iconSize: 24,
            iconEnabledColor: Theme.of(context).primaryColor,
            elevation: 16,
            style: TextStyle(color: Theme.of(context).primaryColor),
            underline: Container(
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            dropdownColor: Theme.of(context).accentColor,
            hint: Text('Kies een hoofdcategorie',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                )),
            onChanged: (String newValue) {
              var _list = Cats.getSubCategories(newValue);
              setState(() {
                _subCat = null;
                _subSubCat = null;
                _mainCat = newValue;
                _subCatsList = _list;
                _subSubCatsList = null;
              });
              widget._callbackMainCats(newValue);
              widget._callbackSubCats(null);
              widget._callbackSubSubCats(null);
            },
            items: _buildItems(),
          ),
          DropdownButton<String>(
            value: _subCat,
            isExpanded: true,
            elevation: 16,
            icon: Icon(Icons.arrow_drop_down_circle),
            iconSize: 24,
            iconEnabledColor: Theme.of(context).primaryColor,
            iconDisabledColor: Theme.of(context).hintColor,
            style: TextStyle(color: Theme.of(context).primaryColor),
            underline: Container(
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            dropdownColor: Theme.of(context).accentColor,
            hint: Text(
              _mainCat == null
                  ? 'Kies eerst een hoofdcategorie'
                  : 'Kies een subcategorie',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            onChanged: (String newValue) {
              var _list = Cats.getSubSubCategories(_mainCat, newValue);
              setState(() {
                _subSubCat = null;
                _subCat = newValue;
                _subSubCatsList = _list;
              });
              widget._callbackSubCats(newValue);
              widget._callbackSubSubCats(null);
            },
            items: _buildSubItems(),
          ),
          if (_subSubCatsList != null && _subSubCatsList.length > 0)
            DropdownButton<String>(
              items: _buildSubSubItems(),
              value: _subSubCat,
              icon: Icon(Icons.arrow_drop_down_circle),
              iconSize: 24,
              iconEnabledColor: Theme.of(context).primaryColor,
              iconDisabledColor: Theme.of(context).hintColor,
              isExpanded: true,
              elevation: 16,
              style: TextStyle(color: Theme.of(context).primaryColor),
              underline: Container(
                height: 1,
                color: Theme.of(context).primaryColor,
              ),
              dropdownColor: Theme.of(context).accentColor,
              hint: Text(
                _subCat == null
                    ? 'Kies eerst een subcategorie'
                    : 'Kies je categorie',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              onChanged: (String newValue) {
                setState(() {
                  _subSubCat = newValue;
                });
                widget._callbackSubSubCats(newValue);
              },
            ),
        ]);
  }
}
