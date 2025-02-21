import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aplicativo/generated/l10n.dart';

class EstatisticasPage extends StatefulWidget {
  final List<Map<String, dynamic>> pulseiras;

  EstatisticasPage({required this.pulseiras});

  @override
  _EstatisticasPageState createState() => _EstatisticasPageState();
}

class _EstatisticasPageState extends State<EstatisticasPage> {
  int _selectedIndex = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String _temperatura = "-";

  @override
  void initState() {
    super.initState();
    _fetchTemperature();
  }

  void _fetchTemperature() {
    if (widget.pulseiras.isNotEmpty) {
      String pulseiraId = widget.pulseiras[_selectedIndex]['id'].toString();
      _database.child('pulseira/$pulseiraId/temperatura').onValue.listen((event) {
        final data = event.snapshot.value;
        setState(() {
          _temperatura = data != null ? data.toString() : S.of(context).notAvailable;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).statistics),
      ),
      body: widget.pulseiras.isEmpty
          ? Center(child: Text(S.of(context).noBracelets))
          : Column(
              children: [
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
                            _selectedIndex = index;
                          });
                          _fetchTemperature();
                        },
                      );
                    },
                  ),
                ),
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
                            '${S.of(context).temperature}: $_temperatura',
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
