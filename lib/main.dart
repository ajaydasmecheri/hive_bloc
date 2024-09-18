
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sec_hive/src/domain/models/event_model.dart';
import 'package:sec_hive/src/presentation/views/homepage/homepage.dart';

void main(List<String> args)  async{
  await Hive.initFlutter();
   if(!Hive.isAdapterRegistered(HiveModelAdapter().typeId))
  {
    Hive.registerAdapter(HiveModelAdapter());
  }
  runApp(const Root());
  
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}