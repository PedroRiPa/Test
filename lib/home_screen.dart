import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';
import 'package:prueba_tecnica_gse/features/events/presentation/screens/events_screen.dart';
import 'package:prueba_tecnica_gse/features/favorites/presentation/screens/favorites_screen.dart';

import 'features/weather/screens/weather_screen.dart';


// 1. Se convierte a ConsumerStatefulWidget para poder usar Riverpod y mantener el estado local
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    // 2. Se observa el estado de la conexión a internet
    final connectivity = ref.watch(connectivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      // 3. Se usa un Column para poder poner el banner encima del contenido de la pantalla
      body: Column(
        children: [
          // 4. Este es el banner que solo aparece si no hay conexión
          if (connectivity.hasValue && connectivity.value == ConnectivityResult.none)
            Container(
              width: double.infinity,
              color: Colors.red.shade700,
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Sin conexión. Mostrando últimos datos cargados.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          
          // 5. El Expanded asegura que el contenido de la pantalla ocupe el resto del espacio
          Expanded(
            child: Center(
              child: _screens.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Clima',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}