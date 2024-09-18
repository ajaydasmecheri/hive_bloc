import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sec_hive/src/domain/functions/hive_functions.dart';
import 'package:sec_hive/src/domain/models/event_model.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventLoading()) {
    on<LoadEvents>((event, emit) async {
      try {
        final events = await getEvent();
        emit(EventLoaded(events.toList()));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<AddEvent>((event, emit) async {
      try {
        await addEvent(event.event);
        add(LoadEvents()); 
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<UpdateEvent>((event, emit) async {
      try {
        await updateEvent(event.event);
        add(LoadEvents()); 
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });

    on<DeleteEvent>((event, emit) async {
      try {
        await deleteEvent(event.id);
        add(LoadEvents()); 
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
  }
}
