import 'package:flutter/material.dart';
import 'package:Tecnofit/pages/home.dart';
import 'package:Tecnofit/pages/login.dart';
import 'package:Tecnofit/pages/perfil.dart';
import 'package:Tecnofit/pages/recuperar_email.dart';
import 'package:Tecnofit/pages/recuperar_senha.dart';
import 'package:Tecnofit/pages/sign_up.dart';
import 'package:Tecnofit/stores/user_store.dart';
import 'pages/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TecnoFit',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(UserStore()),
        '/home': (context) => HomeScreen(UserStore()),
        '/recupera_password': (context) => ForgotPasswordScreen(), // Nova rota para recuperação de senha
        '/recupera_email': (context) => ForgotEmailScreen(),
        '/register': (context) => SignUpScreen(),
        '/perfil': (context) => PerfilScreen(UserStore()),
      },
    );
  }
}
