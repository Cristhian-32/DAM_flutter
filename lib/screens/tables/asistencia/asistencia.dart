import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistenciaForm.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({Key? key});

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  List<AsistenciaModel> asistencia = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Asistencias'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(
              builder: (context) => FutureBuilder<List<AsistenciaModel>>(
                future: Provider.of<AsistenciaApi>(context, listen: true)
                    .index(TokenUtil.TOKEN)
                    .then((value) => value.data),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AsistenciaModel>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Algo salió mal: ${snapshot.error.toString()}",
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<AsistenciaModel> asistencia = snapshot.data!;
                    print(asistencia.length);
                    return _buildListView(asistencia);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para exportar a Excel
                exportAsistenciaToExcel(asistencia);
              },
              child: Text('Exportar a Excel'),
            ),
            ElevatedButton(
            onPressed: ()async{

              final result = await FilePicker.platform.pickFiles();
              List<String>? files = result?.files.map((e)=>e.path).cast<String>().toList();
              if(files == null) return;
              await Share.shareFiles(files); 

            },
            child: Text('pick file'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AsistenciaForm(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(List<AsistenciaModel> asistencia) {
    return ListView.builder(
      itemCount: asistencia.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
                'Semestre: ${asistenciax.level}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${asistenciax.date}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAsistencia(context, asistenciax.id);
            },
          ),
        );
      },
    );
  }

  void _deleteAsistencia(BuildContext context, int asistenciaId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Deseas eliminar esta asistencia?"),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Eliminar'),
              onPressed: () async {
                Navigator.of(context).pop();
                // Lógica para eliminar la asistencia utilizando la API correspondiente
                try {
                  // Llama a la API para eliminar la asistencia utilizando el asistenciaId
                  await Provider.of<AsistenciaApi>(context, listen: false)
                      .delete(TokenUtil.TOKEN, asistenciaId);

                  // Realiza cualquier otra acción necesaria después de eliminar la asistencia
                } catch (error) {
                  // Maneja cualquier error que pueda ocurrir durante la eliminación
                  print('Error al eliminar la asistencia: $error');
                }
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void exportAsistenciaToExcel(List<AsistenciaModel> asistencia) {
    // Crear un nuevo archivo Excel
    var excel = Excel.createExcel();

    // Crear una nueva hoja en el archivo Excel
    Sheet sheetObject = excel['Asistencia'];

    // Escribir los encabezados de columna en la primera fila
    List<String> headers = ['Código', 'Semestre', 'Fecha'];
    for (var col = 0; col < headers.length; col++) {
      CellIndex cellIndex =
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0);
      sheetObject.cell(cellIndex).value = headers[col];
    }

    // Escribir los datos de asistencia en las filas siguientes
    for (var row = 0; row < asistencia.length; row++) {
      AsistenciaModel asistenciax = asistencia[row];
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
          .value = asistenciax.code;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
          .value = asistenciax.level;
      sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
          .value = asistenciax.date;
    }

    // Guardar el archivo Excel en el sistema de archivos
    saveExcel(excel, 'asistencia.xlsx');
  }

  Future<void> saveExcel(Excel excel, String fileName) async {
    try {
      var bytes = excel.encode();
      var dir = await getExternalStorageDirectory();

      if (dir != null) {
        print('Directorio de almacenamiento externo: ${dir.path}');

        var file = File('${dir.path}/$fileName');

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        await file.writeAsBytes(
            bytes!); // Conversión explícita para asegurar que bytes no sea nulo

        print('Archivo guardado correctamente en: ${file.path}');
      } else {
        print('No se pudo obtener el directorio de almacenamiento externo');
      }
    } catch (e) {
      print('Error al guardar el archivo Excel: $e');
    }
  }
}
