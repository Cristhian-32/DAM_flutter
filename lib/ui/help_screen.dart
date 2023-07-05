import 'package:flutter/material.dart';
import 'package:flutter_manager/comp/CustomAppBar.dart';
import 'package:flutter_manager/theme/AppTheme.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class HelpScreenu extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreenu> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  void accion() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //color: AppTheme.nearlyWhite,
      debugShowCheckedModeBanner: false,
      themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: AppTheme.themeData,
      home: SafeArea(
        top: false,
        child: Scaffold(
          /*appBar: new AppBar(
            title: Text(
              'SysCovid19',
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),*/
          appBar: CustomAppBar(accionx: accion as Function),
          //backgroundColor: AppTheme.nearlyWhite,
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 16,
                    right: 16),
                child: Image.asset('assets/imagen/user-login-icon.png'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'How can we help you?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: const Text(
                  'It looks like you are experiencing problems\nwith our sign up process. We are here to\nhelp so please get in touch with us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              if (_supportState)
                const Text('This device is supported')
              else
                const Text('This device is supported'),
              const Divider(height: 100),
              ElevatedButton(
                onPressed: _getAvailableBiometrics,
                child: const Text('Get AVAVAVA'),
              ),
              const Divider(height: 100),
              ElevatedButton(
                onPressed: _authenticate,
                child: Text('Autenticación con huella'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Chat with Us',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticate = await auth.authenticate(
          localizedReason: 'Debes autenticarte para utilizar el app',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      print("Authenticated :$authenticate");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print("List of avalable :$availableBiometrics");

    if (!mounted) {
      return;
    }
  }
}
