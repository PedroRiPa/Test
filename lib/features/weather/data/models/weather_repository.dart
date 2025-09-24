import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prueba_tecnica_gse/features/weather/data/models/weather_model.dart';
import 'weather_api_services.dart';

class WeatherRepository {
  final WeatherApiService _apiService;
  static const _forecastCacheKey = 'last_forecast_cache';
  static const _eventsCacheKey = 'last_events_cache';

  WeatherRepository(this._apiService);

  Future<Weather> getWeatherForecast(String location, bool isOnline) async {
    if (isOnline) {
      try {
        final weather = await _apiService.getWeatherForecast(location);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_forecastCacheKey, json.encode(weather.toJson()));
        return weather;
      } catch (e) {
        return _loadFromCache(_forecastCacheKey);
      }
    } else {
      return _loadFromCache(_forecastCacheKey);
    }
  }

  Future<Weather> getWeatherEvents(String location, bool isOnline) async {
     if (isOnline) {
      try {
        final weather = await _apiService.getWeatherEvents(location);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_eventsCacheKey, json.encode(weather.toJson()));
        return weather;
      } catch (e) {
        return _loadFromCache(_eventsCacheKey);
      }
    } else {
      return _loadFromCache(_eventsCacheKey);
    }
  }

  Future<Weather> _loadFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(key);
    if (cachedJson != null) {
      return Weather.fromJson(json.decode(cachedJson));
    } else {
      throw Exception('No hay conexión y no hay datos guardados.');
    }
  }
}