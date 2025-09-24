import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prueba_tecnica_gse/features/weather/data/models/weather_model.dart';

class FavoritesRepository {
  static const _favoritesKey = 'favorite_events';

  String _getEventId(Event event) {
    return '${event.datetime}_${event.headline.hashCode}';
  }

  Future<void> saveFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final eventId = _getEventId(event);
    final eventJson = json.encode(event.toJson()); 

    final List<String> favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    if (!favoriteIds.contains(eventId)) {
      favoriteIds.add(eventId);
      await prefs.setStringList(_favoritesKey, favoriteIds);
    }
    await prefs.setString(eventId, eventJson);
  }

  Future<void> removeFavorite(Event event) async {
    final prefs = await SharedPreferences.getInstance();
    final eventId = _getEventId(event);

    final List<String> favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    favoriteIds.remove(eventId);
    await prefs.setStringList(_favoritesKey, favoriteIds);
    await prefs.remove(eventId);
  }

  Future<List<Event>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    final List<Event> favorites = [];

    for (String id in favoriteIds) {
      final eventJson = prefs.getString(id);
      if (eventJson != null) {
        favorites.add(Event.fromJson(json.decode(eventJson)));
      }
    }
    return favorites;
  }
}