import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistenciaForm.dart';
import 'package:provider/provider.dart';

class AsistenciaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Asistencias'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a la página principal!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Provider<AsistenciaApi>(
                      create: (_) => AsistenciaApi.create(),
                      child: AsistenciaForm(),
                    ),
                  ),
                );
              },
              child: Text('Registrar Nueva Asistencia'),
            ),
          ],
        ),
      ),
    );
  }
}
