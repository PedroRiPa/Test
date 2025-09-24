import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_gse/features/weather/data/models/weather_model.dart';
// Importa tu widget reutilizable
import '../../../weather/presentation/provider.dart';
import 'event_detail_card.dart'; 

class EventDetailScreen extends ConsumerWidget { // Cambiado a ConsumerWidget
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Añadido WidgetRef
    // Observa si el evento actual es un favorito
    final isFavorite = ref.watch(favoritesProvider.select((favs) => favs.any((e) => e.datetime == event.datetime && e.headline == event.headline)));

    return Scaffold(
      appBar: AppBar(
        title: Text(event.headline),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              final notifier = ref.read(favoritesProvider.notifier);
              if (isFavorite) {
                notifier.removeFavorite(event);
              } else {
                notifier.addFavorite(event);
              }
            },
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Ahora usamos el widget EventDetailCard importado
              EventDetailCard(
                title: 'Evento',
                content: event.headline,
                icon: Icons.label_important_outline,
              ),
              const SizedBox(height: 16),
              EventDetailCard(
                title: 'Fecha y Hora',
                content: event.datetime,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              EventDetailCard(
                title: 'Titular',
                content: event.headline,
                icon: Icons.subtitles_outlined,
              ),
              const SizedBox(height: 16),
              EventDetailCard(
                title: 'Descripción Completa',
                content: event.description,
                icon: Icons.description_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}