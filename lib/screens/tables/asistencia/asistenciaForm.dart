import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';

import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';

class AsistenciaForm extends StatefulWidget {
  final AsistenciaModel? asistencia;
  AsistenciaForm({this.asistencia});
  @override
  _AsistenciaFormState createState() => _AsistenciaFormState();

}

class _AsistenciaFormState extends State<AsistenciaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int activityId = 0;
  TextEditingController code = TextEditingController();
  TextEditingController level = TextEditingController();

  @override
  _AsistenciaFormState createState() => _AsistenciaFormState();
  
  @override
  void dispose() {
    code.dispose();
    level.dispose();
    super.dispose();
  }

  void _createAsistencia() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro Satisfactorio'),
        ),
      );
      _formKey.currentState!.save();
      AsistenciaModel mp = AsistenciaModel.unlaunched();
      mp.activityId = activityId;
      mp.code = code.text;
      mp.level = level.text;
      mp.date = "";

      var api = await Provider.of<AsistenciaApi>(context, listen: false)
          .store(TokenUtil.TOKEN, mp);
      print("ver: ${api.toJson()['success']}");
      if (api.toJson()['success'] == true) {
        Navigator.pop(context, true); // Cambio aquí
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No están bien los datos de los campos!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un ID válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  activityId = int.tryParse(value!) ?? 0;
                },
              ),
              TextFormField(
                controller: code,
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un código válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: level,
                decoration: InputDecoration(labelText: 'Semestre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un semestre válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _createAsistencia();
                  });
                },
                child: Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}