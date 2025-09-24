import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prueba_tecnica_gse/features/weather/data/models/weather_model.dart';
import '../../favorites/data/models/favorites_repository';
import '../data/models/weather_api_services.dart';
import '../data/models/weather_repository.dart';


final apiServiceProvider = Provider<WeatherApiService>((ref) {
  return WeatherApiService();
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WeatherRepository(apiService);
});

final locationProvider = StateProvider<String>((ref) => 'Detectando...');


final weatherForecastProvider = FutureProvider.family<Weather, String>((ref, location) async {
  // Leemos el estado de la conexión
  final connectivity = ref.watch(connectivityProvider).value;
  final isOnline = connectivity != ConnectivityResult.none;

  final repository = ref.watch(weatherRepositoryProvider);
  // Pasamos el estado de la conexión al repositorio
  return repository.getWeatherForecast(location, isOnline);
});

final weatherEventsProvider = FutureProvider.family<Weather, String>((ref, location) async {
  final connectivity = ref.watch(connectivityProvider).value;
  final isOnline = connectivity != ConnectivityResult.none;

  final repository = ref.watch(weatherRepositoryProvider);
  return repository.getWeatherEvents(location, isOnline);
});

final currentPlacemarkProvider = FutureProvider<Placemark>((ref) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos de ubicación fueron denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Los permisos de ubicación están permanentemente denegados.');
  }

  
  final position = await Geolocator.getCurrentPosition();

  final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    return placemarks.first;
  } else {
    return Future.error('No se pudo encontrar una dirección para la ubicación actual.');
  }
});


final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());

class FavoritesNotifier extends StateNotifier<List<Event>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = await _repository.getFavorites();
  }

  Future<void> addFavorite(Event event) async {
    await _repository.saveFavorite(event);
    state = [...state, event];
  }

  Future<void> removeFavorite(Event event) async {
    await _repository.removeFavorite(event);
    state = state.where((e) => e.datetime != event.datetime || e.headline != event.headline).toList();
  }

  bool isFavorite(Event event) {
    return state.any((e) => e.datetime == event.datetime && e.headline == event.headline);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Event>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  // Usamos .map para transformar la lista de resultados en uno solo
  return Connectivity().onConnectivityChanged.map((listOfResults) {
    // La lógica es simple: si en la lista de conexiones está 'none', 
    // consideramos que el dispositivo está offline.
    if (listOfResults.contains(ConnectivityResult.none)) {
      return ConnectivityResult.none;
    }
    // Si no, tomamos el primer resultado de la lista como el estado principal.
    return listOfResults.first;
  });
});