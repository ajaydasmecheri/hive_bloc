import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sec_hive/src/domain/models/event_model.dart';
import 'package:sec_hive/src/presentation/cubit/events/event_bloc.dart';
import 'package:sec_hive/src/presentation/views/homepage/showevent.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController enterEvent = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    Future<void> selectDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null) {
        dateController.text = picked.toLocal().toString().split(' ')[0];
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Event"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShowEvent()),
              );
            },
            icon: const Icon(Icons.event),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => EventBloc(),
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextFormField(
                    controller: enterEvent,
                    decoration: const InputDecoration(
                      hintText: "Enter event",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: "Date",
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_month),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    readOnly: true,
                    onTap: () {
                      selectDate();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final event = HiveModel(
                      event: enterEvent.text.trim(),
                      eventdate: dateController.text.trim(),
                    );
                    context.read<EventBloc>().add(AddEvent(event));
                    enterEvent.clear();
                    dateController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Event added successfully'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
