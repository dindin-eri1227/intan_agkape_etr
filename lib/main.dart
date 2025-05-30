import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(IntanAgKapeApp());
}

class IntanAgKapeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intan Ag-Kape',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Color(0xFFFDF6F0),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
