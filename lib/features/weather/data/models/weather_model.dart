import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  final double latitude;
  final double longitude;
  final String resolvedAddress;
  final String description;
  final List<Day> days;
  final CurrentConditions? currentConditions;
  final List<Event> events;

  Weather({
    required this.latitude,
    required this.longitude,
    required this.resolvedAddress,
    required this.description,
    required this.days,
    this.currentConditions,
    required this.events,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        latitude: (json["latitude"] ?? 0.0).toDouble(),
        longitude: (json["longitude"] ?? 0.0).toDouble(),
        resolvedAddress: json["resolvedAddress"] ?? "Ubicación desconocida",
        description: json["description"] ?? "Sin descripción.",
        days: List<Day>.from((json["days"] ?? []).map((x) => Day.fromJson(x))),
        currentConditions: json["currentConditions"] == null
            ? null
            : CurrentConditions.fromJson(json["currentConditions"]),
        events: _extractEvents(json),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "resolvedAddress": resolvedAddress,
        "description": description,
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
        "currentConditions": currentConditions?.toJson(),
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
      };

  static List<Event> _extractEvents(Map<String, dynamic> json) {
    final List<Event> allEvents = [];
    if (json['events'] != null) {
      allEvents.addAll(List<Event>.from(json['events'].map((x) => Event.fromJson(x))));
    }
    if (json['days'] != null) {
      for (var dayData in json['days']) {
        if (dayData['events'] != null) {
          allEvents.addAll(List<Event>.from(dayData['events'].map((x) => Event.fromJson(x))));
        }
      }
    }
    return allEvents;
  }
}

class Event {
  final String datetime;
  final String type;
  final String headline;
  final String description;

  Event({
    required this.datetime,
    required this.type,
    required this.headline,
    required this.description,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        datetime: json["datetime"] ?? "Fecha desconocida",
        type: json["type"] ?? "Evento sin tipo",
        headline: json["headline"] ?? "Sin titular",
        description: json["description"] ?? json["desc"] ?? "Sin descripción.",
      );

  Map<String, dynamic> toJson() => {
        'datetime': datetime,
        'type': type,
        'headline': headline,
        'description': description,
      };
}

class CurrentConditions {
  final double temp;
  final double feelslike;
  final String conditions;
  final String icon;

  CurrentConditions({
    required this.temp,
    required this.feelslike,
    required this.conditions,
    required this.icon,
  });

  factory CurrentConditions.fromJson(Map<String, dynamic> json) => CurrentConditions(
        temp: (json["temp"] ?? 0.0).toDouble(),
        feelslike: (json["feelslike"] ?? 0.0).toDouble(),
        conditions: json["conditions"] ?? "No disponible",
        icon: json["icon"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "feelslike": feelslike,
        "conditions": conditions,
        "icon": icon,
      };
}

class Day {
  final String datetime;
  final double tempmax;
  final double tempmin;
  final double temp;
  final String conditions;
  final String icon;

  Day({
    required this.datetime,
    required this.tempmax,
    required this.tempmin,
    required this.temp,
    required this.conditions,
    required this.icon,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        datetime: json["datetime"] ?? "",
        tempmax: (json["tempmax"] ?? 0.0).toDouble(),
        tempmin: (json["tempmin"] ?? 0.0).toDouble(),
        temp: (json["temp"] ?? 0.0).toDouble(),
        conditions: json["conditions"] ?? "No disponible",
        icon: json["icon"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime,
        "tempmax": tempmax,
        "tempmin": tempmin,
        "temp": temp,
        "conditions": conditions,
        "icon": icon,
      };
}