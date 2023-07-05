import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistenciaForm.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({super.key});

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
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
                    List<AsistenciaModel> asistencia = snapshot.data!!;
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
            // Cambio aquí
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
}