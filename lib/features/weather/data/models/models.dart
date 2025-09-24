import 'dart:convert';


Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

class Weather {
  final String resolvedAddress;
  final String description;
  final List<Day> days;
  final CurrentConditions currentConditions;

  Weather({
    required this.resolvedAddress,
    required this.description,
    required this.days,
    required this.currentConditions,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        resolvedAddress: json["resolvedAddress"] ?? "Ubicación desconocida",
        description: json["description"] ?? "Sin descripción.",
        days: List<Day>.from((json["days"] ?? []).map((x) => Day.fromJson(x))),
        currentConditions: CurrentConditions.fromJson(json["currentConditions"] ?? {}),
      );
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
        temp: (json["temp"] ?? 0.0)?.toDouble(),
        feelslike: (json["feelslike"] ?? 0.0)?.toDouble(),
        conditions: json["conditions"] ?? "No disponible",
        icon: json["icon"] ?? "",
      );
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
}