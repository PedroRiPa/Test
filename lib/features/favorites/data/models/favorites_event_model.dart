// import 'package:realm/realm.dart';
// import '../../../weather/data/models/weather_model.dart';

// // Genera el esquema de Realm. Ejecuta en la terminal:
// // dart run realm generate
// part 'favorite_event_model.realm.dart';

// @RealmModel()
// class _FavoriteEvent {
//   @PrimaryKey()
//   late String id; // Usaremos datetime como ID único.

//   late String event;
//   late String headline;
//   late String description;
//   late String datetime;
// }

// // Clase de extensión para convertir fácilmente entre el modelo de la API
// // y el modelo de la base de datos.
// extension FavoriteEventAdapter on Event {
//   FavoriteEvent toFavoriteEvent() {
//     return FavoriteEvent(
//       datetime, // Usamos el datetime como ID
//       event: this.event,
//       headline: headline,
//       description: description,
//       datetime: datetime,
//     );
//   }
// }
