import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';

class CurrentLocationWidget extends ConsumerWidget {
  const CurrentLocationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(currentPlacemarkProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return locationAsyncValue.when(
      loading: () => Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01), 
        child: const Center(child: Text("Detectando ubicación...")),
      ),
      error: (error, stack) => Padding(
        padding: EdgeInsets.all(screenWidth * 0.02), 
        child: Text(
          'No se pudo obtener la ubicación: $error',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red.shade300),
        ),
      ),
      data: (placemark) {
        final address = '${placemark.locality}, ${placemark.country}';
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, 
            vertical: screenHeight * 0.01,   
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: screenWidth * 0.04), 
              SizedBox(width: screenWidth * 0.02), 
              Expanded(
                child: Text(
                  address,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
