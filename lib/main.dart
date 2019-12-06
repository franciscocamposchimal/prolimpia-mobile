import 'package:flutter/material.dart';
import 'package:prolimpia_mobile/bloc/provider.dart';
import 'package:prolimpia_mobile/pages/main_page.dart';
import 'package:prolimpia_mobile/shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
          child: MaterialApp(
        title: 'PROLIMPIA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xff03a9f4),
          accentColor:  Color(0xfffdd835),
        ),
        home: MainPage(),
      ),
    );
  }
}

