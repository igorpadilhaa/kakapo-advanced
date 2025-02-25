import 'package:flutter/material.dart';
import 'package:aplicativo/generated/l10n.dart';

class HomePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddPulseira;
  final Function(int) onDeletarPulseira;
  final List<Map<String, dynamic>> pulseiras;

  const HomePage(
      {Key? key,
      required this.onAddPulseira,
      required this.onDeletarPulseira,
      required this.pulseiras})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Função para adicionar uma nova pulseira
  void _adicionarPulseira() {
    final nomeController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).addBracelet),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: S.of(context).name),
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: S.of(context).id),
              keyboardType: TextInputType.text, // Aceita texto e números
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              final nome = nomeController.text;
              final id = idController.text; // Agora o ID é uma string
              if (nome.isNotEmpty && id.isNotEmpty) {
                final newPulseira = {
                  'id': id,
                  'nome': nome
                }; // Usando string para ID
                widget.onAddPulseira(
                    newPulseira); // Passa a pulseira para o MyApp
                Navigator.of(context).pop(); // Fecha o dialog
              }
            },
            child: Text(S.of(context).save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).home),
      ),
      body: widget.pulseiras.isEmpty
          ? Center(child: Text(S.of(context).noBracelets))
          : ListView.builder(
              itemCount: widget.pulseiras.length,
              itemBuilder: (context, index) {
                final pulseira = widget.pulseiras[index];
                return ListTile(
                  title:
                      Text(pulseira['nome'] ?? S.of(context).nameUnavailable),
                  subtitle: Text(
                      '${S.of(context).id}: ${pulseira['id'] ?? S.of(context).idUnavailable}'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                            pulseira['nome'] ?? S.of(context).nameUnavailable),
                        content: Text(
                            '${S.of(context).id}: ${pulseira['id'] ?? S.of(context).idUnavailable}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Fecha o dialog
                            },
                            child: Text(S.of(context).close),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onDeletarPulseira(pulseira['id']);
                              Navigator.of(context).pop(); // Fecha o dialog
                            },
                            child: Text(S.of(context).delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarPulseira,
        child: Image.asset('assets/images/mais.png'),
      ),
    );
  }
}
