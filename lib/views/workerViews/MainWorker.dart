import 'package:flutter/material.dart';
import 'package:first_app/views/workerViews/HomeWorker.dart';

class MainWorker extends StatefulWidget{
  _MainWorker createState() => _MainWorker();
}

class _MainWorker extends State<MainWorker>{
  int _selectedIndex = 0;

  final _widgetOptions = [
    HomeWorker(),
    Text('Index 1: Business')
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