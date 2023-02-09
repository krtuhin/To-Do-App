import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_flutter/screens/home.dart';

void main() async {
  //initialized hive
  await Hive.initFlutter();

  //open a box
  var box = await Hive.openBox("myBox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "To Do App",
      home: Home(),
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}
