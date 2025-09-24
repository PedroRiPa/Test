import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';


class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    final location = ref.watch(locationProvider);
    final forecastAsyncValue = ref.watch(weatherForecastProvider(location));

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Actual'),
      ),
      body: forecastAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Text('Error: $err', textAlign: TextAlign.center),
          ),
        ),
        data: (weather) {
          if (weather.currentConditions == null && weather.days.isEmpty) {
            return const Center(child: Text('No hay datos de clima disponibles.'));
          }

          final currentTemp = weather.currentConditions?.temp;
          final dailyAvgTemp = weather.days.isNotEmpty ? weather.days[0].temp : null;
          final currentConditions = weather.currentConditions?.conditions ?? "No disponible";
          final mapCenter = LatLng(weather.latitude, weather.longitude);
          final Set<Marker> markers = {
            Marker(
              markerId: MarkerId(weather.resolvedAddress),
              position: mapCenter,
              infoWindow: InfoWindow(title: weather.resolvedAddress),
            )
          };

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            children: [
              Text(
                weather.resolvedAddress,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(height: screenHeight * 0.01),
              if (currentTemp != null)
                Text(
                  '${currentTemp.toStringAsFixed(1)}°C',
                  style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              Text(
                currentConditions,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              if (dailyAvgTemp != null)
                Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,   
                  horizontal: screenWidth * 0.08,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 223, 223, 223),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '${dailyAvgTemp.toStringAsFixed(1)}°C',
                  style: textTheme.displayMedium?.copyWith(
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
             
              SizedBox(height: screenHeight * 0.04),
              const Divider(),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Ubicación en el Mapa',
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                height: screenHeight * 0.35,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: mapCenter,
                    zoom: 12.0,
                  ),
                  markers: markers,
                  mapType: MapType.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}