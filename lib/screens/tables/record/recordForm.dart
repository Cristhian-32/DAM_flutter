import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/apis/record_api.dart';
import 'package:flutter_manager/models/RecordModel.dart';


import 'package:flutter_manager/models/asistenciaModel.dart';

import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';

class RecordForm extends StatefulWidget {
  final RecordModel? record;
  RecordForm({this.record});
  @override
  _RecordFormState createState() => _RecordFormState();

}

class _RecordFormState extends State<RecordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int activity_Id = 0;
  int user_Id = 0;
  TextEditingController name = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController school = TextEditingController();
  TextEditingController level = TextEditingController();
  TextEditingController evidence = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();


  @override
  _RecordFormState createState() => _RecordFormState();

  @override
  void dispose() {

    name.dispose();
    code.dispose();
    school.dispose();
    level.dispose();
    evidence.dispose();
    date.dispose();
    time.dispose();



    super.dispose();
  }

  void _createRecord() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro Satisfactorio'),
        ),
      );
      _formKey.currentState!.save();
      RecordModel mp = RecordModel.unlaunched();
      mp.user_id = user_Id;
      mp.activity_id = activity_Id;
      mp.name = name.text;
      mp.code = code.text;
      mp.school = school.text;
      mp.level = level.text;
      mp.evidence = evidence.text;
      mp.date = date.text;
      mp.time = time.text;


      var api = await Provider.of<RecordApi>(context, listen: false)
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
        title: Text('record Form'),
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
                  user_Id = int.tryParse(value!) ?? 0;
                },
              ),
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
                  activity_Id = int.tryParse(value!) ?? 0;
                },
              ),


              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un código válido';
                  }
                  return null;
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
                controller: school,
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
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un código válido';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: evidence,
                decoration: InputDecoration(labelText: 'Semestre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un semestre válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: date,
                decoration: InputDecoration(labelText: 'Semestre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un semestre válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: time,
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
                    _createRecord();
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