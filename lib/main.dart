import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/apis/record_api.dart';
import 'package:flutter_manager/apis/user_api.dart';
import 'package:flutter_manager/screens/loading.dart';
import 'package:flutter_manager/screens/login.dart';
import 'package:flutter_manager/screens/home_screen.dart';
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
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
