import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/config_system.dart';
import 'global.dart' as globals;

void main() async {
  runApp(MyApp());
  globals.serverIP = await ConfigSystem.getServer();
  print(globals.serverIP);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}