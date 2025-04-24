from flask import Flask, jsonify, abort, request

import firebase_admin
from firebase_admin import credentials, db, firestore

cred = credentials.Certificate('firebase.json')

firebase_admin.initialize_app(cred, {
    'databaseURL': ''  
})

# Acesso ao Firestore
firestore_db = firestore.client()


# Inicializa a aplicação Flask
app = Flask(__name__)

# Define o endpoint GET
@app.route('/status/<id>', methods=['GET'])
def obter_valor(id):
    nome = buscar_nome_paciente(id)
    if nome is None:
        abort(404)

    dados = {}
    dados['status'] = buscar_status(id)
    dados['nome'] = nome

    res = jsonify(dados)
    res.headers.add('Access-Control-Allow-Origin', '*')
    return res

def buscar_nome_paciente(pulseira_id):
    doc = firestore_db.document(f"pacientes/{pulseira_id}").get()
    if not doc.exists:
        return None
    
    return doc.get('nome')


def buscar_status(pulseira_id) -> dict:
    query = firestore_db.collection(f"pacientes/{pulseira_id}/status") \
        .order_by("criado_em", direction=firestore.Query.DESCENDING) \
        .limit(10)
    
    docs = []
    for doc in query.stream():
        docs.append(doc.to_dict())
    
    return docs

@app.route('/pulseiras', methods=['GET'])
def obter_pulseiras():
    query = firestore_db.collection('pacientes').stream()
    pulseiras = []
    for doc in query:
        pulseiras.append({
            'id': doc.id,
            'paciente': doc.get('nome')
        })
    
    res = jsonify(pulseiras)
    res.headers.add('Access-Control-Allow-Origin', '*')
    return res


@app.route('/paciente/<codigo_pulseira>', methods=['POST'])
def cadastrar_paciente(codigo_pulseira):
    data = request.get_json()

    if not data or 'nome' not in data or 'pulseira' not in data:
        return jsonify({'erro': 'JSON inválido ou campos ausentes'}), 400

    # Extrai o código da pulseira do corpo
    match = request.match(r"pulseira:\s*([a-fA-F0-9]+)", data['pulseira'])
    if not match or match.group(1) != codigo_pulseira:
        return jsonify({'erro': 'Código da pulseira não corresponde ao especificado na URL'}), 400

    # Dados a serem salvos
    paciente = {
        'nome': data['nome'],
        'pulseira': codigo_pulseira
    }

    # Salva no Firestore
    firestore_db.collection('pacientes').document(codigo_pulseira).set(paciente)

    return jsonify({'mensagem': 'Paciente cadastrado com sucesso!', 'dados': paciente}), 200

@app.route('/risco', methods=['GET'])
def listar_pacientes_em_alerta():
    pacientes_ref = firestore_db.collection('pacientes')
    pacientes_docs = pacientes_ref.stream()

    pacientes_em_alerta = []

    for doc in pacientes_docs:
        codigo_pulseira = doc.id
        paciente_data = doc.to_dict()

        # Acessa subcoleção 'status' (pegando o documento mais recente — pode mudar isso)
        status_docs = firestore_db.collection('pacientes').document(codigo_pulseira).collection('status').stream()

        for status_doc in status_docs:
            status = status_doc.to_dict()

            grau_cianose = status.get('grau_cianose', '').lower()
            grau_ictericia = status.get('grau_ictericia', '').lower()

            if grau_cianose in ['alt', 'mediana'] or grau_ictericia in ['alta', 'mediana']:
                pacientes_em_alerta.append({
                    "nome": paciente_data.get("nome"),
                    "pulseira": paciente_data.get("pulseira"),
                    "grau_cianose": grau_cianose,
                    "grau_ictericia": grau_ictericia
                })
                break  # Já encontrou alerta, não precisa verificar outros status

    res = jsonify(pacientes_em_alerta)
    res.headers.add('Access-Control-Allow-Origin', '*')
    return res, 200

if __name__ == '__main__':
    app.run(debug=True)
