// import 'package:realm/realm.dart';


// class FavoritesDatabaseService {
//   late final Realm _realm;

//   FavoritesDatabaseService() {
//     // Configuración para abrir la base de datos local
//     final config = Configuration.local([FavoriteEvent.schema]);
//     _realm = Realm(config);
//   }

//   // Obtiene todos los eventos favoritos guardados
//   RealmResults<FavoriteEvent> getFavorites() {
//     return _realm.all<FavoriteEvent>();
//   }

//   // Añade un nuevo evento a favoritos
//   Future<void> addFavorite(FavoriteEvent event) async {
//     // 'write' se usa para cualquier operación de escritura (crear, actualizar, borrar)
//     _realm.write(() {
//       _realm.add(event, update: true); // update: true sobrescribe si ya existe
//     });
//   }

//   // Elimina un evento de favoritos usando su ID (datetime)
//   Future<void> removeFavorite(String eventId) async {
//     final eventToRemove = _realm.find<FavoriteEvent>(eventId);
//     if (eventToRemove != null) {
//       _realm.write(() {
//         _realm.delete(eventToRemove);
//       });
//     }
//   }

//   // Verifica si un evento ya está en favoritos
//   bool isFavorite(String eventId) {
//     return _realm.find<FavoriteEvent>(eventId) != null;
//   }
  
//   // Cierra la instancia de la base de datos cuando ya no se necesite
//   void dispose() {
//     _realm.close();
//   }
// }
