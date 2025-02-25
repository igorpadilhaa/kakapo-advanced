import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _temperatura = "-";
  String _batimentos = "-";
  Map<String, dynamic>? _pacienteInfo; // Armazena os dados do paciente

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    if (widget.pulseiras.isNotEmpty) {
      String pulseiraId = widget.pulseiras[_selectedIndex]['id'].toString();

      // 🔥 Buscar temperatura do Realtime Database
      _database
          .child('pulseira/$pulseiraId/temperatura')
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        setState(() {
          _temperatura =
              data != null ? data.toString() : S.of(context).notAvailable;
        });
      });

      // 🔥 Buscar batimentos do Realtime Database
      _database
          .child('pulseira/$pulseiraId/batimentos')
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        setState(() {
          _batimentos =
              data != null ? data.toString() : S.of(context).notAvailable;
        });
      });

      // 🔥 Buscar os dados do paciente no Firestore
      _firestore.collection('pacientes').doc(pulseiraId).get().then((doc) {
        if (doc.exists) {
          setState(() {
            _pacienteInfo = doc.data();
          });
        } else {
          setState(() {
            _pacienteInfo = null;
          });
        }
      }).catchError((error) {
        print("Erro ao buscar paciente no Firestore: $error");
        setState(() {
          _pacienteInfo = null;
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
                        title: Text(
                            pulseira['nome'] ?? S.of(context).nameUnavailable),
                        subtitle: Text(
                            '${S.of(context).id}: ${pulseira['id'] ?? S.of(context).idUnavailable}'),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          _fetchData();
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
                            '${S.of(context).name}: ${widget.pulseiras[_selectedIndex]['nome'] ?? S.of(context).nameUnavailable}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${S.of(context).id}: ${widget.pulseiras[_selectedIndex]['id'] ?? S.of(context).idUnavailable}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${S.of(context).temperature}: $_temperatura',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${S.of(context).heartRate}: $_batimentos',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          _pacienteInfo != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '📋 ${S.of(context).patientData}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '👤 ${S.of(context).name}: ${_pacienteInfo!['nome'] ?? S.of(context).notAvailable}'),
                                    Text(
                                        '📅 ${S.of(context).birthDate}: ${_pacienteInfo!['data_nascimento'] ?? S.of(context).notAvailable}'),
                                    Text(
                                        '📞 ${S.of(context).phone}: ${_pacienteInfo!['telefone'] ?? S.of(context).notAvailable}'),
                                    Text(
                                        '📍 ${S.of(context).address}: ${_pacienteInfo!['endereco'] ?? S.of(context).notAvailable}'),
                                    Text(
                                        '⚠️ ${S.of(context).emergency}: ${_pacienteInfo!['emergencia'] == true ? S.of(context).yes : S.of(context).no}'),
                                  ],
                                )
                              : Text('❌ ${S.of(context).patientNotFound}'),
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
