import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_gse/core/api.dart';
import '../models/weather_model.dart';


class WeatherApiService {
  Future<Weather> getWeatherForecast(String location) async {
    final String url =
        '${ApiConstants.baseUrl}$location/last0days?key=${ApiConstants.apiKey}&unitGroup=metric&include=days,current&lang=es';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return weatherFromJson(response.body);
      } else {
       
        throw Exception(
            'Error al cargar el pronóstico. Código: ${response.statusCode}');
      }
    } catch (e) {
      
      throw Exception('Error de conexión o al procesar la solicitud: $e');
    }
  }

  
  Future<Weather> getWeatherEvents(String location) async {
    final String url =
        '${ApiConstants.baseUrl}$location/last39days?key=${ApiConstants.apiKey}&include=events&lang=es';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return weatherFromJson(response.body);
      } else {
        throw Exception(
            'Error al cargar los eventos. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión o al procesar la solicitud: $e');
    }
  }
}


