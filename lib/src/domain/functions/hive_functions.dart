
import 'package:hive/hive.dart';
import 'package:sec_hive/src/domain/models/event_model.dart';


// Add function
Future<void> addEvent(HiveModel data) async {
  var userDB = await Hive.openBox<HiveModel>("EventBox");
  final _id = await userDB.add(data);
  data.id = _id;
  await data.save(); 
}


// Get function
Future<Iterable<HiveModel>> getEvent() async {
  var userDB = await Hive.openBox<HiveModel>("EventBox");
  return userDB.values;
}


// Delete function
Future<void> deleteEvent(int id) async {
  var userDB = await Hive.openBox<HiveModel>("EventBox");
  await userDB.delete(id);
}


// update function
Future<void> updateEvent(HiveModel updatedEvent) async {
  var userDB = await Hive.openBox<HiveModel>("EventBox");
  final id = updatedEvent.id;
  if (id != null) {
    await userDB.put(id, updatedEvent);
  }
}
