import 'package:flutter/material.dart';
import 'package:flutter_manager/screens/drawner/AppBar.dart';
import 'package:flutter_manager/screens/drawner/NavBar.dart';
import 'package:flutter_manager/screens/tables/ACtividad/actividad.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistencia.dart';

import 'package:flutter_manager/screens/tables/record/record.dart';
import 'package:flutter_manager/util/RoleUtil.dart';
import 'package:flutter_manager/util/TokenUtil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var txtName = ProfileUtil.NAME;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomNavBar(),
      appBar: CustomAppBar(title: 'Inicio'),
      body: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido! ${txtName}',
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
              Visibility(
                visible: RoleGuard.isAdviser(),
                child: ActionCard(
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
              ),
              SizedBox(height: 10),
              Visibility(
                visible: RoleGuard.isAdviser(),
                child: ActionCard(
                  title: 'ASISTENCIA',
                  description: 'Podras LISTAR asistencia de tus eventos',
                  onPressed: () {
                    print("object");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AsistenciaScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: RoleGuard.isAdviser(),
                child: ActionCard(
                  title: 'RECORD',
                  description: 'Listar RECORDS',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordsScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: RoleGuard.isUser(),
                child: ActionCard(
                  title: 'ESTUDIANTES',
                  description: 'Registra tu asistencia, MUY PRONTO',
                  onPressed: () {
                    // Acción para la acción 3
                  },
                ),
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
