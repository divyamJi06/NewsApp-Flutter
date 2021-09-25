import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './views/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './strings/strings.dart';
// import 'package:fluttertoast/fluttertoast.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  LanguageIn language = LanguageIn();
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: language.appName,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: "Top Headlines"),
    );
  }
}
