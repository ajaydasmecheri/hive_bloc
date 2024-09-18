part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {}

class AddEvent extends EventEvent {
  final HiveModel event;

  AddEvent(this.event);

  @override
  List<Object?> get props => [event];
}

class DeleteEvent extends EventEvent {
  final int id;

  DeleteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateEvent extends EventEvent {
  final HiveModel event;

  UpdateEvent(this.event);

  @override
  List<Object?> get props => [event];
}