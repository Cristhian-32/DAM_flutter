import 'package:flutter/material.dart';
import 'package:flutter_manager/screens/tables/actividad.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instituciones Name'),
        backgroundColor: Color.fromARGB(255, 71, 196, 22),
        // Cambiar el color del AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Lógica al presionar el botón de búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Lógica al presionar el botón de notificaciones
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido! Nombre del usuario',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '¿Qué deseas hacer?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              ActionCard(
                title: 'ACTIVIDADES O EVENTOS',
                description: 'Podras CREAR Actividades o Eventos',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActividadScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ActionCard(
                title: 'ASISTENCIA',
                description: 'Podras LISTAR asistencia de tus eventos',
                onPressed: () {
                  // Acción para la acción 2
                },
              ),
              SizedBox(height: 10),
              ActionCard(
                title: 'Acción 3',
                description: 'Descripción de 5 palabras',
                onPressed: () {
                  // Acción para la acción 3
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const ActionCard({
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onPressed,
            label: Text(''),
            icon: Icon(Icons.arrow_forward), // Icono a utilizar
            // Dejar el texto vacío
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 71, 196, 22), // Color del botón
            ),
          ),
        ],
      ),
    );
  }
}
