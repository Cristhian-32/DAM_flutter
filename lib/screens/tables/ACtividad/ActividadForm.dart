import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/comp/DropDownFormField.dart';
import 'package:flutter_manager/models/ActividadModelo.dart';
import 'package:flutter_manager/screens/tables/ACtividad/actividad.dart';
import 'package:flutter_manager/theme/AppTheme.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActividadForm extends StatefulWidget {
  @override
  _ActividadFormState createState() => _ActividadFormState();
}

class _ActividadFormState extends State<ActividadForm> {
  late int _user_id = 0;
  late String _title = "";
  late String _body = "D";
  TextEditingController _date = TextEditingController();
  DateTime? selectedDate;

  var _data = [];
  List<Map<String, String>> lista = [
    {'value': 'A', 'display': 'Activo'},
    {'value': 'D', 'display': 'Desactivo'}
  ];
  List<Map<String, String>> listaEva = [
    {'value': 'SI', 'display': 'SI'},
    {'value': 'NO', 'display': 'NO'}
  ];

  @override
  void initState() {
    super.initState();
    print("ver: ${lista.map((item) => item['value']).toList()}");
    print("verv: ${lista.map((item) => item['display']).toList()}");
  }

  final _formKey = GlobalKey<FormState>();
  GroupController controller = GroupController();
  GroupController multipleCheckController = GroupController(
    isMultipleSelection: true,
  );

  void capturaNombreAct(valor) {
    this._title = valor;
  }

  void capturaUserid(valor) {
    this._user_id = valor;
  }

  void capturaBody(valor) {
    this._body = valor;
  }

  void capturaFecha(valor) {
    this._date.text = valor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 71, 196, 22),
        title: Text(
          "Form. Reg. Actividad",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          color: AppTheme.nearlyWhite,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildDatoCadena(capturaNombreAct, "Nombre Actividad:"),
                _buildDatoCadena(capturaBody, "Descripció Breve"),
                _buildDatoFecha(capturaFecha, "F.Evento"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Cancelar'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Color de fondo del botón
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/actividad');
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing Data'),
                              ),
                            );
                            _formKey.currentState!.save();
                            ActividadModelo mp =
                                new ActividadModelo.unlaunched();
                            mp.user_id = _user_id;
                            mp.title = _title;
                            mp.body = _body;
                            mp.date = _date.value.text;

                            final prefs = await SharedPreferences.getInstance();

                            var api = await Provider.of<ActividadApi>(
                              context,
                              listen: false,
                            ).createActividad(TokenUtil.TOKEN, mp);

                            if (api.toJson()['success'] == true) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActividadScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No estan bien los datos de los campos!',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Guardar'),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(
                              255, 54, 244, 54), // Color de fondo del botón
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatoEntero(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Id es campo Requerido';
        }
        return null;
      },
      onSaved: (String? value) {
        obtValor(int.parse(value!));
      },
    );
  }

  Widget _buildDatoCadena(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Nombre Requerido!';
        }
        return null;
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }

  Widget _buildDatoLista(
    Function obtValor,
    _dato,
    String label,
    List<dynamic> listaDato,
  ) {
    return DropDownFormField(
      titleText: label,
      hintText: 'Seleccione',
      value: _dato,
      onSaved: (value) {
        setState(() {
          obtValor(value);
        });
      },
      onChanged: (value) {
        setState(() {
          obtValor(value);
        });
      },
      dataSource: listaDato,
      textField: 'display',
      valueField: 'value',
    );
  }

  Future<void> _selectDate(BuildContext context, Function obtValor) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(pickedDate);

      setState(() {
        selectedDate = pickedDate;
        obtValor(formattedDate);
      });
    }
  }

  Widget _buildDatoFecha(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: _date,
      keyboardType: TextInputType.datetime,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Nombre Requerido!';
        }
        return null;
      },
      onTap: () {
        _selectDate(context, obtValor);
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }
}
