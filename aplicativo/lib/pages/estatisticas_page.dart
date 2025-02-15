import 'package:flutter/material.dart';
import 'package:aplicativo/generated/l10n.dart';

class EstatisticasPage extends StatefulWidget {
  final List<Map<String, dynamic>> pulseiras;

  // Construtor da página que recebe a lista de pulseiras
  EstatisticasPage({
    required this.pulseiras,
  });

  @override
  _EstatisticasPageState createState() => _EstatisticasPageState();
}

class _EstatisticasPageState extends State<EstatisticasPage> {
  int _selectedIndex = 0;  // Índice da pulseira selecionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).statistics),  // Tradução para "Estatísticas"
      ),
      body: widget.pulseiras.isEmpty
          ? Center(child: Text(S.of(context).noBracelets)) // Exibe uma mensagem quando não há pulseiras
          : Column(
              children: [
                // Lista de pulseiras
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.pulseiras.length,
                    itemBuilder: (context, index) {
                      final pulseira = widget.pulseiras[index];
                      return ListTile(
                        title: Text(pulseira['nome'] ?? S.of(context).nameUnavailable),
                        subtitle: Text('${S.of(context).id}: ${pulseira['id'] ?? S.of(context).idUnavailable}'),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;  // Mudar a pulseira selecionada
                          });
                        },
                      );
                    },
                  ),
                ),

                // Exibe os dados da pulseira selecionada
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${S.of(context).name}: ${widget.pulseiras[_selectedIndex]['nome']}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${S.of(context).id}: ${widget.pulseiras[_selectedIndex]['id']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${S.of(context).temperature}: ${widget.pulseiras[_selectedIndex]['temperatura'] ?? S.of(context).notAvailable}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${S.of(context).heartRate}: ${widget.pulseiras[_selectedIndex]['batimentos'] ?? S.of(context).notAvailable}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${S.of(context).oxygenation}: ${widget.pulseiras[_selectedIndex]['oximento'] ?? S.of(context).notAvailable}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
