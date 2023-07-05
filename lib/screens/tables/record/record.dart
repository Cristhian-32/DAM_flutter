import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/record_api.dart';
import 'package:flutter_manager/models/RecordModel.dart';
import 'package:flutter_manager/screens/tables/record/recordForm.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de record'),
        backgroundColor: Color.fromARGB(255, 70, 238, 3),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(
              builder: (context) => FutureBuilder<List<RecordModel>>(
                future: Provider.of<RecordApi>(context, listen: true)
                    .index(TokenUtil.TOKEN)
                    .then((value) => value.data),
                builder: (BuildContext context,
                    AsyncSnapshot<List<RecordModel>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Algo salió mal: ${snapshot.error.toString()}",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<RecordModel> record = snapshot.data!!;
                    return _buildListView(record);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
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
              builder: (context) => RecordForm(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 61, 236, 8),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildListView(List<RecordModel> record) {
    return ListView.builder(
      itemCount: record.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        RecordModel recordx = record[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 19, 235, 55),
          ),
          title: Text(
            recordx.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Fecha: ${recordx.user_id}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.user_id}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.activity_id}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.name}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.code}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.level}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.evidence}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.date}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fecha: ${recordx.time}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAsistencia(context, recordx.recordId);
            },
          ),
        );
      },
    );
  }

  void _deleteAsistencia(BuildContext context, int recordId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Deseas eliminar esta record?"),
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
                try {
                  await Provider.of<RecordApi>(context, listen: false)
                      .delete(TokenUtil.TOKEN, recordId);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Asistencia eliminada exitosamente'),
                    backgroundColor: Colors.green,
                  ));

                  setState(() {});
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error al eliminar la asistencia'),
                    backgroundColor: Colors.red,
                  ));
                  print('Error al eliminar la asistencia: $error');
                }
              },
            ),
          ],
        );
      },
    );
  }
}