import 'package:flutter/material.dart';

class Categories {
  static final List<DropdownMenuItem<Object>> _categories = [
    DropdownMenuItem(child: Text('No Category'), value: 'Kies je categorie'),
    DropdownMenuItem(child: Text('Interior'), value: 'interior'),
    DropdownMenuItem(child: Text('Babyrooms'), value: 'babyrooms'),
    DropdownMenuItem(child: Text('Bedlinnen'), value: 'bedlinnen'),
    DropdownMenuItem(child: Text('Kids rooms'), value: 'kidsrooms'),
    DropdownMenuItem(child: Text('Accessories'), value: 'accessories'),
    DropdownMenuItem(child: Text('Clothing'), value: 'clothing'),
    DropdownMenuItem(child: Text('Babies'), value: 'babies'),
    DropdownMenuItem(child: Text('Girls'), value: 'girls'),
    DropdownMenuItem(child: Text('Boys'), value: 'boys'),
    DropdownMenuItem(child: Text('Safety'), value: 'safety'),
    DropdownMenuItem(child: Text('Chairs'), value: 'chairs'),
    DropdownMenuItem(child: Text('Playpens'), value: 'playpens'),
    DropdownMenuItem(child: Text('Babyphones'), value: 'babyphones'),
    DropdownMenuItem(child: Text('On the move'), value: 'on the move'),
    DropdownMenuItem(child: Text('Car Seats'), value: 'car seats'),
    DropdownMenuItem(child: Text('Buggies'), value: 'buggies'),
    DropdownMenuItem(child: Text('Strollers'), value: 'strollers'),
    DropdownMenuItem(child: Text('Toys'), value: 'Toys'),
    DropdownMenuItem(child: Text('Games'), value: 'Games'),
    DropdownMenuItem(child: Text('Construction'), value: 'Construction'),
    DropdownMenuItem(child: Text('Hobbies'), value: 'Hobbies'),
    DropdownMenuItem(child: Text('Outdoors'), value: 'Outdoors'),
    DropdownMenuItem(child: Text('Lego'), value: 'Lego'),
    DropdownMenuItem(child: Text('Playmobil'), value: 'Playmobil'),
    DropdownMenuItem(child: Text('Disney'), value: 'Disney'),
    DropdownMenuItem(child: Text('Star Wars'), value: 'Star Wars'),
    DropdownMenuItem(child: Text('Fortnite'), value: 'Fortnite'),
    DropdownMenuItem(child: Text('Pokemon'), value: 'Pokemon')
  ];

  static List<DropdownMenuItem<Object>> get categories {
    return _categories;
  }
}
