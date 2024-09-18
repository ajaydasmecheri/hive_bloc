import 'package:hive/hive.dart';
part 'event_model.g.dart';


@HiveType(typeId: 1)
class HiveModel extends HiveObject{

  @HiveField(0)
  int? id;

  @HiveField(1)
  String event;

  @HiveField(2)
  String eventdate;

  HiveModel({ required this.event, required this.eventdate, this.id});

}