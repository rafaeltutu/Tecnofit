import 'package:Tecnofit/pages/menu_drawer.dart';
import 'package:Tecnofit/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class PerfilScreen extends StatefulWidget {
  final UserStore userStore;

  PerfilScreen(this.userStore);

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
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
            title: Text('Perfil'),
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
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: widget.userStore.avatar != null &&
                                    widget.userStore.avatar!.isNotEmpty
                                    ? NetworkImage(widget.userStore.avatar!)
                                    : AssetImage('assets/user_profile.jpg') as ImageProvider,
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.userStore.firstName} ${widget.userStore.lastName}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '067 - Ph.D Sports Ventura',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
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
                                        SizedBox(width: 10),
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Row(
                              children: [
                                Expanded(child: Text('Data de vencimento')),
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
                            leading: Icon(Icons.email),
                            title: Text('Email: ${widget.userStore.email ?? 'N/A'}'),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text('Telefone: (00) 00000-0000'), // Exemplo de campo de telefone
                          ),
                          ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text('Cidade: Curitiba'), // Exemplo de campo de cidade
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/editarPerfil');
                              },
                              child: Text('Editar Perfil'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
