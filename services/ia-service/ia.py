import joblib
import tensorflow as tf
import numpy as np

modelo_grau_cianose = joblib.load('rf-cianose.joblib')
modelo_grau_ictericia = joblib.load('rf-ictericia.joblib')

modelo_variacao = tf.keras.models.load_model('nn-variacao.keras')

def calcular(rgb_atual, rgb_anterior) -> dict:
    global modelo_grau_cianose, modelo_grau_ictericia, modelo_variacao

    x = rgb_anterior + rgb_atual
    x = np.array(x).reshape(1, -1)

    grau_cianose = modelo_grau_cianose.predict(x)
    grau_ictericia = modelo_grau_ictericia.predict(x)

    variacao_ictericia, variacao_cianose = modelo_variacao.predict(x)

    print('ict:', variacao_ictericia)
    print('cia:', variacao_cianose)

    return {
        "ictericia": {
            "grau": grau_ictericia.item(),
            "variacao": variacao_ictericia[0][0].item()
        },
        "cianose": {
            "grau": grau_cianose.item(),
            "variacao": variacao_cianose[0][0].item()
        }
    }



res = calcular([209, 162, 128], [140, 118, 130])
print(res)

res = calcular([140, 118, 130], [209, 162, 128 ])
print(res)
