import 'package:Tecnofit/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_mobx/flutter_mobx.dart';


class LoginScreen extends StatefulWidget {
  final UserStore userStore;

  LoginScreen(this.userStore);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('https://reqres.in/api/login');
      final response = await http.post(
        url,
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        widget.userStore.login(data['token']); // Armazena o token no UserStore

        // Navegar para a tela principal após login
        Navigator.pushReplacementNamed(context, '/home');

      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        String errorMessage;

        if (errorData['error'] == 'user not found') {
          errorMessage = 'Usuário não encontrado';
        } else if (errorData['error'] == 'Missing password') {
          errorMessage = 'Por favor, insira sua senha';
        } else if (errorData['error'] == 'Missing email or username') {
          errorMessage = 'Por favor, insira seu e-mail';
        } else {
          errorMessage = 'Erro: ${errorData['error']}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro desconhecido. Tente novamente.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de rede: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.8,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo do App
                      Center(
                        child: Image.asset(
                          'imagens/03.png',
                          width: constraints.maxWidth > 1200
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Texto de boas-vindas
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá!',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Acesse sua conta para planejar seus próximos treinos.',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Campo de E-mail
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'E-mail'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira seu e-mail';
                          } else if (!value.contains('@')) {
                            return 'Insira um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // Campo de Senha
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          } else if (value.length < 6) {
                            return 'A senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      // Links de "Esqueceu a senha" e "Esqueceu o e-mail"
                      Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/recupera_password');
                            },
                            child: Text('Esqueceu a senha?'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/recupera_email');
                            },
                            child: Text('Esqueceu o e-mail utilizado?'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Botão de Login
                      Observer(
                        builder: (_) => _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[600],
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Botão para registro
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('Ainda não tem conta? Logon'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
