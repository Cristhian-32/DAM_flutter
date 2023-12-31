import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/apis/record_api.dart';
import 'package:flutter_manager/apis/user_api.dart';
import 'package:flutter_manager/screens/login.dart';
import 'package:flutter_manager/screens/home_screen.dart';
import 'package:flutter_manager/screens/tables/ACtividad/ActividadEdit.dart';
import 'package:flutter_manager/screens/tables/ACtividad/ActividadForm.dart';
import 'package:flutter_manager/screens/tables/ACtividad/actividad.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistencia.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<UserApi>(
          create: (_) => UserApi.create(),
        ),
        Provider<AsistenciaApi>(
          create: (_) => AsistenciaApi.create(),
        ),
        Provider<ActividadApi>(
          create: (_) => ActividadApi.create(),
        ),
        Provider<RecordApi>(
          create: (_) => RecordApi.create(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // ...
        '/actividad_form': (context) => ActividadForm(),
        '/actividad': (context) => ActividadScreen(),
        '/asistencia': (context) => AsistenciaScreen(),
        //'/actividad_edit': (context) => ActividadFormEdit(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
