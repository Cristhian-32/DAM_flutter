import 'package:flutter/material.dart';
import 'package:flutter_manager/models/user.dart';
import 'package:flutter_manager/screens/register.dart';
import 'package:flutter_manager/apis/user_api.dart';
import 'package:flutter_manager/util/RoleUtil.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_manager/screens/home_screen.dart';

class MainLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<UserApi>(
      create: (_) => UserApi.create(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blue),
        home: const LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoggedIn = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  List<String> roles = [];
  var token;
  bool loading = false;

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      print("Usuario: ${txtEmail} clave:${txtPassword}");

      final prefs = await SharedPreferences.getInstance();
      final api = Provider.of<UserApi>(context, listen: false);
      final user =
          UserModel(name: "", email: txtEmail.text, password: txtPassword.text);
      bool logged = false;
      api.login(user).then((value) {
        roles = value.roles;
        token = value.tokenType + " " + value.accessToken;
        prefs.setString("token", token);
        prefs.setString("roles", value.roles.join(","));
        RoleUtil.ROLE = roles;
        TokenUtil.TOKEN = token;
        print(token);
        print(roles);
        logged = true;

        if (logged == true) {
          print("si se logeo");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      }).catchError((onError) {
        print(onError.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${onError.toString()}')));
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Credenciales Incorrectas' : null,
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
                controller: txtPassword,
                validator: (val) =>
                    val!.isEmpty ? 'Requiere minimo 6 caracteres' : null,
                decoration: const InputDecoration(
                    labelText: 'Contraseña',
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
                        'Ingresar',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
                          padding: MaterialStateProperty.resolveWith(
                              (states) => EdgeInsets.symmetric(vertical: 10))),
                      onPressed: () async {
                        if (txtEmail.text.isNotEmpty &&
                            txtPassword.text.isNotEmpty) {
                          setState(() {
                            loading = true;
                            _loginUser();
                          });
                        }
                      },
                    ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No tienes cuenta? '),
                  GestureDetector(
                    child: Text('Registrate',
                        style: TextStyle(color: Colors.blue)),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                          (route) => false);
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}
