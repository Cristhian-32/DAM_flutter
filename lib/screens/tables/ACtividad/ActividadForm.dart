import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/models/ActividadModelo.dart';
import 'package:flutter_manager/screens/tables/ACtividad/actividad.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_manager/models/ActividadModelo.dart';

class ActividadFormScreen extends StatefulWidget {
  @override
  _ActividadFormScreenState createState() => _ActividadFormScreenState();
}

class _ActividadFormScreenState extends State<ActividadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Actividad'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Cuerpo'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa el cuerpo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'fecha'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa el cuerpo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Guardar'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveActividad();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveActividad() {
    final actividadApi = Provider.of<ActividadApi>(context, listen: false);
    final token = TokenUtil.TOKEN;

    ActividadModelo actividad = ActividadModelo(
      title: _titleController.text,
      body: _bodyController.text,
      date: _dateController.text,
    );

    actividadApi.createActividad(token, actividad).then((response) {
      if (response.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ActividadScreen()),
        );
      } else {
        // Manejar errores aquí
      }
    }).catchError((error) {
      // Manejar errores aquí
    });
  }
}
