import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prueba_tecnica_gse/features/weather/data/models/weather_model.dart';
import 'package:prueba_tecnica_gse/features/weather/presentation/provider.dart';
import '../../../weather/screens/current_location.dart';
import 'event_detail_screen.dart';
import 'event_list_item.dart';


class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final location = ref.watch(locationProvider);
    final eventsAsyncValue = ref.watch(weatherEventsProvider(location));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Últimos 30 Días'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: CurrentLocationWidget(),
            ),
          ),
          const SliverToBoxAdapter(child: Divider()),
          eventsAsyncValue.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error al cargar eventos: $error')),
            ),
            data: (weatherData) {
              final events = weatherData.events;
              final days = weatherData.days;
              if (days.isEmpty && events.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No hay datos disponibles.')),
                );
              }

              return SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader('Eventos Registrados', screenWidth, screenHeight),
                  if (events.isNotEmpty)
                    ...events.map((event) => EventListItem(
                          event: event,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailScreen(event: event),
                              ),
                            );
                          },
                        ))
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.03,
                      ),
                      child: const Center(child: Text('No se encontraron eventos.')),
                    ),
                  
                  SizedBox(height: screenHeight * 0.02),
                  _buildSectionHeader('Resumen Diario', screenWidth, screenHeight),
                  ...days.map((day) => _buildDayListItem(context, day, screenWidth, screenHeight)),
                ]),
              );
            },
          ),
        ],
      ),
    );
  }

  // Firma del método corregida
  Widget _buildSectionHeader(String title, double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.04,
        screenHeight * 0.02,
        screenWidth * 0.04,
        screenHeight * 0.01,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDayListItem(BuildContext context, Day day, double screenWidth, double screenHeight) {
    double toCelsius(double fahrenheit) {
      return (fahrenheit - 32) * 5 / 9;
    }

    final tempMaxCelsius = toCelsius(day.tempmax);
    final tempMinCelsius = toCelsius(day.tempmin);
    final formattedDate = DateFormat.yMMMMd('es_ES').format(DateTime.parse(day.datetime));

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.0075,
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today_outlined),
        title: Text(formattedDate),
        subtitle: Text(day.conditions),
        trailing: Text(
          '${tempMaxCelsius.toStringAsFixed(0)}°C / ${tempMinCelsius.toStringAsFixed(0)}°C',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}