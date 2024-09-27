import 'package:Tecnofit/pages/perfil.dart';
import 'package:Tecnofit/stores/user_store.dart';
import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomDrawer extends StatefulWidget {
  final UserStore userStore;

  CustomDrawer(this.userStore);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  void initState() {
    super.initState();
    // Chama a função para buscar os dados do usuário quando o drawer é inicializado
    fetchUserData();
  }

  // Função para buscar os dados dos usuários e comparar o e-mail
  Future<void> fetchUserData() async {
    try {
      final url = Uri.parse('https://reqres.in/api/users?page=1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Percorrer a lista de usuários para encontrar o e-mail correspondente
        for (var user in data['data']) {
          if (user['email'] == widget.userStore.email) {
            // Armazenar os dados do usuário no MobX store
            widget.userStore.setUserInfo(
              user['first_name'],
              user['last_name'],
              user['email'],
              user['avatar'],
            );
            return;
          }
        }

        // Caso o e-mail não seja encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário não encontrado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar dados dos usuários')),
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Observer(
            builder: (_) => DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: widget.userStore.avatar != null && widget.userStore.avatar!.isNotEmpty
                            ? NetworkImage(widget.userStore.avatar!)
                            : AssetImage('imagens/user_profile.jpg') as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Expanded( // Ajusta o conteúdo para ocupar o espaço disponível
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.userStore.firstName} ${widget.userStore.lastName}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // Impede que o texto transborde
                            ),
                            Text(
                              '067 - Ph.D Sports Ventura',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis, // Impede que o texto transborde
                            ),
                            Row(
                              children: [
                                Text(
                                  '50 pts',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 10), // Substitui o Spacer por um SizedBox menor
                                Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'ATIVO',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Impede que o texto transborde
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // Itens do Menu
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Row(
              children: [
                Expanded(child: Text('Data de vencimento')), // Ajusta o texto para não transbordar
                Text(
                  '29/05/25',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Início'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilScreen(widget.userStore), // Passando a mesma instância
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text('Check-in'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Meu treino'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico de presença'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Cronômetro'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Venda de produtos'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Contratos'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.run_circle_outlined),
            title: Text('Complete seu treino'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Avaliações físicas'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.poll),
            title: Text('Enquetes'),
            onTap: () {
              // Adicione o comportamento desejado aqui
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {
              // Adicione o comportamento desejado aqui
              widget.userStore.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
