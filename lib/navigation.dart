import 'package:flutter/material.dart';
import 'package:tester6/AssetsPage.dart';
import 'package:tester6/ControlPage.dart';
import 'package:tester6/MapsScreen.dart';
import 'package:tester6/StatisticsPage.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>[
    'Control',
    'Statistics',
    'Image & Assets',
    'Maps and Location'
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    ControlScreen(),
    StatisticsScreen(),
    const ImageAssetsScreen(),
    MapsScreen(), // Add your Maps and Location screen here
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu icon press
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.control_camera),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Image & Assets',
          ),
          BottomNavigationBarItem( 
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, 
        onTap: _onItemTapped,
      ),
    );
  }
}

