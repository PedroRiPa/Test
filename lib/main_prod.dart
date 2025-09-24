import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba_tecnica_gse/app/app.dart'; 

void main() {
  // Configuraciones para PRODUCCIÓN
  runApp(
    const ProviderScope(
      child: MyApp(appName: "Weather App", environment: 'prod',), 
    ),
  );
}