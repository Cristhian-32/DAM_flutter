import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistenciaForm.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class AsistenciaScreen extends StatefulWidget {
  @override
  _AsistenciaScreenState createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  @override
  void initState() {
    super.initState();

  }
  Future onGoBack(dynamic value) async {
    setState(() {
      print(value);
    });
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Asistencias'),
      ),
      body: Builder(
        builder: (context) => FutureBuilder<List<AsistenciaModel>>(
          future: Provider.of<AsistenciaApi>(context, listen: true)
              .index(TokenUtil.TOKEN)
              .then((value) => value.data),
          builder: (BuildContext context,
              AsyncSnapshot<List<AsistenciaModel>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<AsistenciaModel> asistencia = snapshot.data!!;
              return _buildListView(context, asistencia);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _exportAsistencia(context);
            },
            child: Icon(Icons.share),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _navigateToAsistenciaForm(context, null); // Agregar nueva asistencia
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<AsistenciaModel> asistencia) {
    return ListView.builder(
      itemCount: asistencia.length,
      itemBuilder: (context, index) {
        AsistenciaModel asistenciax = asistencia[index];
        return ListTile(
          leading: CircleAvatar(),
          title: Text(
            asistenciax.code,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nivel: ${asistenciax.level}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _navigateToAsistenciaForm(context, asistenciax); // Editar asistencia
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, asistenciax);
                },
              ),
            ],
          ),
          onTap: () {
            _navigateToAsistenciaForm(context, asistenciax); // Editar asistencia
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, AsistenciaModel asistencia) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de eliminar esta asistencia?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                _deleteAsistencia(context, asistencia);
                
              },
            ),
          ],
        );
      },
    );
  
  }

  Future<void> _deleteAsistencia(
      BuildContext context, AsistenciaModel asistencia) async {
    final asistenciaApi = Provider.of<AsistenciaApi>(context, listen: false);
    final response =
        await asistenciaApi.delete(TokenUtil.TOKEN, asistencia.id);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Asistencia eliminada exitosamente'),
      ));
      Provider.of<AsistenciaApi>(context, listen: false)
          .index(TokenUtil.TOKEN)
          .then((value) => onGoBack(value));
          
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al eliminar la asistencia'),
      ));
    }
  }

  Future<void> _exportAsistencia(BuildContext context) async {
    final asistenciaApi = Provider.of<AsistenciaApi>(context, listen: false);
    final response = await asistenciaApi.index(TokenUtil.TOKEN);
    if (response.success) {
      final asistencia = response.data;
      await _exportToCSV(asistencia);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al exportar la asistencia'),
      ));
    }
  }

  Future<void> _exportToCSV(List<AsistenciaModel> asistencia) async {
    List<List<dynamic>> rows = [];
    rows.add(['Código', 'Nivel']);
    for (var asistenciax in asistencia) {
      rows.add([asistenciax.code, asistenciax.level]);
    }

    final csvData = ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/asistencias.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareFiles([path], text: 'Exportar a CSV');
  }

  void _navigateToAsistenciaForm(
      BuildContext context, AsistenciaModel? asistencia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsistenciaForm(asistencia: asistencia), // Cambiar a AsistenciaForm
      ),
    ).then((value) {
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Asistencia actualizada exitosamente'),
        ));
        Provider.of<AsistenciaApi>(context, listen: false)
            .index(TokenUtil.TOKEN)
            .then((value) {
          setState(() {}); // Actualizar el estado para refrescar la lista de asistencias
        });
      }
    });
  }
  
}
