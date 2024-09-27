import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _recoveryOption = 'email'; // Define a opção padrão como "email"
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Voltar para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            // Título
            Text(
              'Esqueceu?',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Subtítulo
            Text(
              'Escreva seu e-mail de acesso, ou número de celular cadastrado, e nós te ajudaremos o mais rápido possível!',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            // Opção de recuperação
            RadioListTile<String>(
              value: 'email',
              groupValue: _recoveryOption,
              title: Text('Recuperar por email'),
              onChanged: (value) {
                setState(() {
                  _recoveryOption = value!;
                  _emailController.clear(); // Limpa o campo ao mudar de opção
                });
              },
            ),
            RadioListTile<String>(
              value: 'whatsapp',
              groupValue: _recoveryOption,
              title: Text('Recuperar por WhatsApp'),
              onChanged: (value) {
                setState(() {
                  _recoveryOption = value!;
                  _emailController.clear(); // Limpa o campo ao mudar de opção
                });
              },
            ),
            SizedBox(height: 20),
            // Campo de texto de e-mail ou celular
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: _recoveryOption == 'email' ? 'E-mail' : 'Número de celular',
                      suffixIcon: Icon(Icons.check_circle, color: Colors.green),
                    ),
                    keyboardType: _recoveryOption == 'email'
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    inputFormatters: _recoveryOption == 'whatsapp'
                        ? [MaskedInputFormatter('(##) #####-####')] // Máscara de celular
                        : [],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, insira ${_recoveryOption == 'email' ? 'o e-mail' : 'o número de celular'}';
                      }
                      if (_recoveryOption == 'email') {
                        // Validação simples para e-mail
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Por favor, insira um e-mail válido';
                        }
                      } else {
                        // Validação para número de celular com 11 dígitos
                        if (value.length < 15) {
                          return 'O número de celular deve conter 11 dígitos';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  // Botão de recuperar senha
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Lógica para recuperação de senha aqui
                        print('Recuperação de senha enviada');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Recuperação de senha enviada')),
                      );
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[600],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Recuperar senha',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botão de voltar ao login
                  TextButton(
                    onPressed: () {

                      Navigator.pushNamed(context, '/login'); // Navegar para a tela de login
                    },
                    child: Text(
                      'Acho que me lembrei!',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
