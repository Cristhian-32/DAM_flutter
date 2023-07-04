import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/activity_api.dart';
import 'package:flutter_manager/models/ActividadModelo.dart';
import 'package:flutter_manager/screens/drawner/AppBar.dart';
import 'package:flutter_manager/util/TokenUtil.dart';

class ActividadScreen extends StatefulWidget {
  ActividadScreen({Key? key}) : super(key: key);

  @override
  _ActividadScreenState createState() => _ActividadScreenState();
}

class _ActividadScreenState extends State<ActividadScreen> {
  late List<ActividadModelo> actividades = [];

  @override
  void initState() {
    super.initState();
    fetchActividades();
  }

  Future<void> fetchActividades() async {
    try {
      final resp = await ActividadApi.create().getActividad(TokenUtil.TOKEN);
      if (resp.success) {
        setState(() {
          actividades = resp.data;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(resp.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch activities.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Actividades',
      ),
      body: ListView.builder(
        itemCount: actividades.length,
        itemBuilder: (context, index) {
          final actividad = actividades[index];
          return ListTile(
            title: Text('ID: ${actividad.id.toString()}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${actividad.title}'),
                Text('Body: ${actividad.body}'),
                Text('Date: ${actividad.date}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
