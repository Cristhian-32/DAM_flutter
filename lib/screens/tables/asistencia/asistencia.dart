import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/asistencia_api.dart';
import 'package:flutter_manager/models/asistenciaModel.dart';
import 'package:flutter_manager/screens/tables/asistencia/asistenciaForm.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';

class AsistenciaScreen extends StatelessWidget {
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
    );
  }

  Widget _buildListView(List<AsistenciaModel> asistencia) {
    return ListView.builder(
      itemCount: asistencia.length,
      itemBuilder: (context, index) {
        AsistenciaModel asistenciax = asistencia[index];
        return ListTile(
          leading: CircleAvatar(
              //backgroundImage: AssetImage("assets/imagen/man-icon.png"),
              ),
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
                'Fecha: ${asistenciax.level}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
