import 'package:flutter/material.dart';
import 'package:prueba_tecnica_gse/features/weather/data/models/weather_model.dart';

class EventListItem extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventListItem({
    super.key,
    required this.event,
    required this.onTap,
  });

  String _translateEventType(String type) {
    final typeLower = type.toLowerCase();

    const translations = {
      'hail': 'Granizo',
      'tornado': 'Tornado',
      'wind': 'Viento Fuerte',
      'rain': 'Lluvia',
      'snow': 'Nieve',
      'thunderstorm': 'Tormenta Eléctrica',
      'fog': 'Niebla',
      'earthquake' : 'Terremoto',
      
    };
    return translations[typeLower] ?? (type.isEmpty ? "" : type[0].toUpperCase() + type.substring(1));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
        title: Text(
          _translateEventType(event.type),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        
        subtitle: Text(
          event.headline,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}