import 'package:flutter/material.dart';
import 'package:prueba_tecnica_gse/features/events/presentation/screens/events_screen.dart';
import 'package:prueba_tecnica_gse/features/favorites/presentation/screens/favorites_screen.dart';
import '../features/weather/screens/weather_screen.dart';

class MyApp extends StatefulWidget {
  final String environment;

  const MyApp({super.key, required this.environment, required String appName});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    WeatherScreen(),
    EventsScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App - ${widget.environment}',
      debugShowCheckedModeBanner: widget.environment == "DEV",
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_getAppBarTitle(_selectedIndex)),
        ),
        body: Center(
          child: _screens.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined),
              activeIcon: Icon(Icons.cloud),
              label: 'Clima',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Eventos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF0D47A1),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Pronóstico del Clima';
      case 1:
        return 'Eventos Climáticos';
      case 2:
        return 'Mis Favoritos';
      default:
        return 'Weather App';
    }
  }
}
