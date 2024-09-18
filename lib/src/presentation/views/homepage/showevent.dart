// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sec_hive/src/domain/models/event_model.dart';
import 'package:sec_hive/src/presentation/cubit/events/event_bloc.dart';

class ShowEvent extends StatelessWidget {
  const ShowEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: BlocProvider(
        create: (context) => EventBloc()..add(LoadEvents()),
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventError) {
              return Center(
                  child: Text('Error: ${state.message}',
                      style: const TextStyle(color: Colors.red)));
            } else if (state is EventLoaded) {
              final events = state.events;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        event.event,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        event.eventdate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Wrap(
                        spacing: 8.0,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedEvent =
                                  await _showEditDialog(context, event);
                              if (updatedEvent != null) {
                                context
                                    .read<EventBloc>()
                                    .add(UpdateEvent(updatedEvent));
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<EventBloc>()
                                  .add(DeleteEvent(event.id!));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child:
                      Text('No events found', style: TextStyle(fontSize: 16)));
            }
          },
        ),
      ),
    );
  }

  Future<HiveModel?> _showEditDialog(BuildContext context, HiveModel event) {
    final eventController = TextEditingController(text: event.event);
    final dateController = TextEditingController(text: event.eventdate);

    return showDialog<HiveModel>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: eventController,
                decoration: const InputDecoration(labelText: 'Event'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(dateController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateController.text =
                        picked.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  HiveModel(
                    id: event.id,
                    event: eventController.text,
                    eventdate: dateController.text,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
