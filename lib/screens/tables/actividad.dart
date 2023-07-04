import 'package:flutter/material.dart';
import 'package:flutter_manager/screens/drawner/AppBar.dart';

class ActividadScreen extends StatelessWidget {
  ActividadScreen(String s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'actividad',
      ),
      body: Center(
        child: Text(
          '¡Bienvenido a la página principal!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
