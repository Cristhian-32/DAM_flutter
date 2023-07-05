import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/models/ActividadModelo.dart';
import 'package:flutter_manager/screens/drawner/AppBarAct.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';

class ActividadScreen extends StatelessWidget {
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
                    // Acción al presionar el botón de asistencia
                    // Aquí puedes agregar la lógica para registrar la asistencia
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteActividad(BuildContext context, int id) {
    final actividadApi = Provider.of<ActividadApi>(context, listen: false);
    final token = TokenUtil.TOKEN;

    actividadApi.deleteActividad(token, id).then((response) {
      // Aquí puedes manejar la respuesta de la API después de eliminar la actividad
    }).catchError((error) {
      // Aquí puedes manejar los errores en caso de que ocurra algún problema en la solicitud
    });
  }
}
