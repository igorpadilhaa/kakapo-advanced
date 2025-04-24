import firebase_admin
from firebase_admin import credentials, db, firestore
import time

from ia import calcular

cred = credentials.Certificate('firebase.json')

firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://kakapo-86895-default-rtdb.firebaseio.com/' 
})
firestore_db = firestore.client()


def monitor_changes():
    ref = db.reference('pulseira')
    while True:
        data = ref.get()
        if data:
            process_data_and_insert_into_firestore(data)
            
        time.sleep(10)

def busca_ultimo_status(pulseira: str):
    query = firestore_db.collection(f"pacientes/{pulseira}/status") \
        .order_by("criado_em", direction=firestore.Query.DESCENDING) \
        .limit(1)
    
    docs = query.stream()
    for doc in docs:
        return doc
    
    return None


def process_data_and_insert_into_firestore(data: dict):
    for pulseira_id, leitura in data.items():
        ultimo_status = busca_ultimo_status(pulseira_id)

        print('Leitura atual:', leitura)
        print('Ultimo status:', ultimo_status.to_dict())

        if ultimo_status is None:
            novo_status = status_inicial(leitura)
        else:
            if leitura.get('rgb') == None:
                continue
            
            novo_status = processar_novo_status(ultimo_status, leitura)
        
        salvar_status(pulseira_id, novo_status)


def status_inicial(leitura):
    return {
        'rgb': leitura['rgb'],
        'temperatura': leitura['temperatura']
    }


def processar_novo_status(ultimo_status, leitura_atual):
    ultimo_rgb = ultimo_status.get('rgb')
    resultados = calcular(leitura_atual['rgb'], ultimo_rgb)
    resultados['rgb'] = leitura_atual['rgb']
    resultados['temperatura'] = leitura_atual['temperatura']

    return resultados


def salvar_status(pulseira_id, novo_status):
    novo_status['criado_em'] = firestore.SERVER_TIMESTAMP
    firestore_db.collection(f"pacientes/{pulseira_id}/status").add(novo_status)


monitor_changes()
