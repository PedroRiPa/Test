import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prueba_tecnica_gse/app/app.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';
void main() async{
  
  const String environment = "DEV";

  WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('es_ES', null);
    final initialLocation = await _getInitialLocation();
    runApp(
      
       ProviderScope(
        overrides: [
        locationProvider.overrideWith((ref) => initialLocation),
      ],
        child: MyApp(environment: environment, appName: 'dev',),
    ),
  );
}

Future<String> _getInitialLocation() async {
  try {
    final container = ProviderContainer();
    final placemark = await container.read(currentPlacemarkProvider.future);
    container.dispose();

    return '${placemark.locality},${placemark.isoCountryCode}';
  } catch (e) {
    return 'Medellin,CO'; 
  }
}