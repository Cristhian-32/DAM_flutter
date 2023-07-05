import 'package:flutter/material.dart';
import 'package:flutter_manager/apis/user_api.dart';
import 'package:flutter_manager/models/user.dart';
import 'package:flutter_manager/screens/home_screen.dart';
import 'package:flutter_manager/screens/register.dart';
import 'package:flutter_manager/util/RoleUtil.dart';
import 'package:flutter_manager/util/TokenUtil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Borrar todos los datos almacenados

    // Restablecer los valores en las utilidades
    ProfileUtil.NAME = "";
    ProfileUtil.EMAIL = "";
    RoleUtil.ROLE = [" "];
    TokenUtil.TOKEN = "";

    // Navegar a la pantalla de inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _loginUser() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      final api = Provider.of<UserApi>(context, listen: false);
      final user = UserModel(name: "", email: email, password: password);

      setState(() {
        _loading = true;
      });

      try {
        final value = await api.login(user);
        final prefs = await SharedPreferences.getInstance();

        final name = value.profile.name;
        final email = value.profile.email;
        final roles = value.roles;
        final token = value.tokenType + " " + value.accessToken;

        prefs.setString("token", token);
        prefs.setString("roles", roles.join(","));
        prefs.setString("name", name);
        prefs.setString("email", email);

        ProfileUtil.NAME = name;
        ProfileUtil.EMAIL = email;
        RoleUtil.ROLE = roles;
        TokenUtil.TOKEN = token;

        print(name);
        print(email);
        print(token);
        print(roles);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(),
              Container(
                padding: const EdgeInsets.only(left: 35, top: 130),
                child: Text(
                  'Bienvenido\nde Nuevo',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Correo',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextField(
                              controller: _passwordController,
                              style: const TextStyle(),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Contraseña',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Recordar',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Checkbox(
                                  value: false,
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xff4c505b),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: _loginUser,
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage()),
                                        (route) => false);
                                  },
                                  child: const Text(
                                    'Registrarse',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ButtonStyle(),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    '¿Has olvidado\ntu contraseña?',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
