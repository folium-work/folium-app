import 'package:flutter/material.dart';
import 'package:first_app/views/clientViews/HomeClient.dart';

class MainClient extends StatefulWidget{
  _MainClient createState() => _MainClient();
}

class _MainClient extends State<MainClient>{
  int _selectedIndex = 0;

  final _widgetOptions = [
    HomeClient(),
    Text('Index 1: Business'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(children: <Widget>[
        new Container(color: Theme.of(context).backgroundColor),
        new Center(child: _widgetOptions.elementAt(_selectedIndex))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Início')),
          BottomNavigationBarItem(icon: Icon(Icons.whatshot), title: Text('Promoções')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}