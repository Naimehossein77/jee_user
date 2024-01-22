import 'package:flutter/material.dart';
import 'package:jee_user/Screens/BottomNavigationScreens/Favriots.dart';
import 'package:jee_user/Screens/BottomNavigationScreens/ProductList.dart';
import 'package:jee_user/Screens/BottomNavigationScreens/SearchProduct.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static const List<Widget> _widgetOption = <Widget>[
    ProductList(),
    SearchItem(),
    FavriotsList()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOption.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepOrange,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Browse",
              backgroundColor: Colors.deepOrange),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
              backgroundColor: Colors.deepOrange),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: "Favorits",
              backgroundColor: Colors.deepOrange),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
