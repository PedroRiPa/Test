import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';
import '../../../events/presentation/screens/event_detail_screen.dart';
import '../../../events/presentation/screens/event_list_item.dart';


class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteEvents = ref.watch(favoritesProvider);

    if (favoriteEvents.isEmpty) {
      return const Center(
        child: Text(
          'Aquí se mostrarán los eventos guardados como favoritos.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: favoriteEvents.length,
      itemBuilder: (context, index) {
        final event = favoriteEvents[index];
        return Dismissible(
          key: Key('${event.datetime}_${event.headline.hashCode}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            ref.read(favoritesProvider.notifier).removeFavorite(event);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${event.type} eliminado de favoritos')),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: EventListItem(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(event: event),
                ),
              );
            },
          ),
        );
      },
    );
  }
}