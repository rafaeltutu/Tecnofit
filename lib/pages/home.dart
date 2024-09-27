import 'package:Tecnofit/pages/menu_drawer.dart';
import 'package:Tecnofit/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final UserStore userStore;

  HomeScreen(this.userStore);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Chama a função para carregar os dados do usuário quando a tela é carregada
    fetchUserData(widget.userStore, context);
  }

  // Função para buscar os dados do usuário da API
  Future<void> fetchUserData(UserStore userStore, BuildContext context) async {
    try {
      final url = Uri.parse('https://reqres.in/api/users/4');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Armazena os dados do usuário no MobX store
        userStore.setUserInfo(
          data['data']['first_name'],
          data['data']['last_name'],
          data['data']['email'],
          data['data']['avatar'],
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar dados do usuário')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de rede. Verifique sua conexão.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define a largura limite para ser considerado uma tela grande (computador)
        bool isLargeScreen = constraints.maxWidth > 800;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: isLargeScreen
              ? null // Remove o AppBar em telas grandes, pois o menu já está sempre visível
              : AppBar(
            title: Text('Home'),
          ),
          drawer: isLargeScreen ? null : CustomDrawer(widget.userStore), // Drawer para telas pequenas
          body: Row(
            children: [
              // Se for uma tela grande, exiba o Drawer sempre visível na lateral
              if (isLargeScreen)
                Container(
                  width: 250, // Defina a largura que você deseja para o menu em telas grandes
                  child: CustomDrawer(widget.userStore),
                ),
              Expanded(
                child: Center(
                  child: Observer(
                    builder: (_) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bem-vindo(a), ${widget.userStore.firstName} ${widget.userStore.lastName}!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email: ${widget.userStore.email}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),


                        // Exibição da imagem com base nas dimensões da tela
                        Image.asset(
                          'imagens/03.png',
                          width: constraints.maxWidth > 1800
                              ? constraints.maxWidth * 0.5
                              : constraints.maxWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
