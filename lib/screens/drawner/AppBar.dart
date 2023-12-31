import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 71, 196, 22),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Lógica al presionar el botón de búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Lógica al presionar el botón de notificaciones
            },
          ),
        ],
      ),
    );
  }
}
