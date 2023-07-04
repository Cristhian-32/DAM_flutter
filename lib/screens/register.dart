import 'package:flutter/material.dart';
import 'package:flutter_manager/models/user.dart';
import 'package:flutter_manager/screens/login.dart';
import 'package:flutter_manager/apis/user_api.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      //print("Usuario: ${txtEmail} clave:${txtPassword}");
      if (passwordController.text == passwordConfirmController.text) {
        final api = Provider.of<UserApi>(context, listen: false);
        final user = UserModel(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text);
        bool logged = false;

        api.store(user).then((value) {
          logged = true;
          if (logged == true) {
            setState(() {
              print("Registro exitoso");
              _redirectToHome();
            });
          }
        }).catchError((onError) {
          print(onError.toString());
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${onError.toString()}')));
          setState(() {
            loading = false;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        loading = false;
      }
    }
  }

  void _redirectToHome() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                controller: nameController,
                validator: (val) => val!.isEmpty ? 'Nombre no valido' : null,
                decoration: const InputDecoration(
                    labelText: 'Nombre de Usuario',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (val) =>
                    val!.isEmpty ? 'Dirección de correo no valido' : null,
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                validator: (val) =>
                    val!.length < 6 ? 'Requiere minimo 6 caracteres' : null,
                decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordConfirmController,
                decoration: const InputDecoration(
                    labelText: 'Confirma tu contraseña',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black))),
              ),
              SizedBox(
                height: 10,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : TextButton(
                      child: Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
                          padding: MaterialStateProperty.resolveWith(
                              (states) => EdgeInsets.symmetric(vertical: 10))),
                      onPressed: () async {
                        if (nameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            passwordConfirmController.text.isNotEmpty) {
                          setState(() {
                            _registerUser();
                          });
                        }
                      },
                    ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.blue),
                    padding: MaterialStateProperty.resolveWith(
                        (states) => EdgeInsets.symmetric(vertical: 10))),
                onPressed: () async {
                  setState(() {
                    loading = false;
                    _redirectToHome();
                  });
                },
              ),
            ],
          )),
    );
  }
}
