import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/models/ActividadModelo.dart';
import 'package:flutter_manager/screens/drawner/AppBarAct.dart';
import 'package:flutter_manager/screens/tables/ACtividad/ActividadEdit.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';

class ActividadScreen extends StatefulWidget {
  const ActividadScreen({super.key});

  @override
  State<ActividadScreen> createState() => _ActividadScreenState();
}

class _ActividadScreenState extends State<ActividadScreen> {
  List<ActividadModelo> actividade = [];
  final List<Color> colors = [
    Color(0xFFC5E1A5), // Verde pastel
    Color(0xFFFFCC80), // Naranja pastel
    Color(0xFFB39DDB), // Lila pastel
    Color(0xFF80CBC4), // Verde azulado pastel
    Color(0xFFFFAB91), // Melocotón pastel
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomActAppBar(title: 'Lista de Actividades'),
      body: Builder(
        builder: (context) => FutureBuilder<List<ActividadModelo>>(
          future: Provider.of<ActividadApi>(context, listen: false)
              .getActividad(TokenUtil.TOKEN)
              .then((value) => value.data),
          builder: (BuildContext context,
              AsyncSnapshot<List<ActividadModelo>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}",
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<ActividadModelo> actividad = snapshot.data!;
              print(actividad.length);
              return _buildListView(actividad, context);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            exportAsistenciaToExcel(actividade);
            // Lógica para el botón flotante
          },
          child: Icon(Icons.explicit_outlined, size: 40),
          backgroundColor: Colors.green,
          heroTag: null,
          elevation: 6.0,
          mini: false,
        ),

        
      ),
    );
  }

  Widget _buildListView(List<ActividadModelo> actividad, BuildContext context) {
    return ListView.builder(
      itemCount: actividad.length,
      itemBuilder: (context, index) {
        ActividadModelo actividadx = actividad[index];
        final color = colors[index % colors.length];

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: color,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 16,
            ),
            title: Text(
              actividadx.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${actividadx.body}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${actividadx.date}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActividadFormEdit(modelA: actividadx)),
                    );
                    // Acción al presionar el botón de más (+)
                    // Aquí puedes agregar la lógica para añadir
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () {
                    _deleteActividad(context, actividadx.id);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/asistencia');
                    // Acción al presionar el botón de asistencia
                    // Aquí puedes agregar la lógica para registrar la asistencia
                  },
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
        );
      },
    );
  }

  void _deleteActividad(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar esta actividad?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final actividadApi =
                    Provider.of<ActividadApi>(context, listen: false);
                final token = TokenUtil.TOKEN;

                actividadApi.deleteActividad(token, id).then((response) {
                  // Aquí puedes manejar la respuesta de la API después de eliminar la actividad
                }).catchError((error) {
                  // Aquí puedes manejar los errores en caso de que ocurra algún problema en la solicitud
                });

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ActividadScreen())); // Cerrar el diálogo
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

void exportAsistenciaToExcel(List<ActividadModelo> actividad) {
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
  for (var row = 0; row < actividad.length; row++) {
    ActividadModelo actividadx = actividad[row];
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row + 1))
        .value = actividadx.title;
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row + 1))
        .value = actividadx.body;
    sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row + 1))
        .value = actividadx.date;
  }

  // Guardar el archivo Excel en el sistema de archivos
  saveExcel(excel, 'Actividades.xlsx');
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
