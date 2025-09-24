import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';


class CurrentLocationWidget extends ConsumerWidget {
  const CurrentLocationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(currentPlacemarkProvider);

    return locationAsyncValue.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Center(child: Text("Detectando ubicación...")),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'No se pudo obtener la ubicación: $error',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red.shade300),
        ),
      ),
      data: (placemark) {
        final address = '${placemark.locality}, ${placemark.country}';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 8),
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

