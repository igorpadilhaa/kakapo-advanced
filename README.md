Perfeito! Aqui está a versão atualizada do README com essas correções: remoção da parte do aplicativo e adição de que a IA **já identifica variações de icterícia e cianose** com base nas mudanças de cor da pele.

---

# Projeto-VictorC-RyanK-IgorP_UFRR_2024

<br />  
<p align="center">
  <a href="">
    <img src="https://user-images.githubusercontent.com/49700354/114078715-a61b2f00-987f-11eb-8eef-6fd7cfc17d33.png" alt="" width="80" height="80">
    <img src="https://github.com/VictorH456/MIC014Aula2-VictorC-RyanK-IgorP_UFRR_2024/blob/main/imagens/maloca.png" alt="" width="80" height="80">
    <img src="https://github.com/VictorH456/MIC014Aula2-VictorC-RyanK-IgorP_UFRR_2024/blob/main/imagens/dcc.png" alt="" width="80" height="80">
  </a>
  <h1 align="center">Projeto Pulseira Inteligente</h1>
  <p align="center">
    <img src="https://github.com/VictorH456/kakapo-2-sprint0/blob/main/Imagens/logo2.jpeg">
  </p>

## 1. Pulseira Inteligente para Monitoramento de Temperatura e Cor da Pele

O projeto consiste no desenvolvimento de uma **pulseira inteligente** para monitoramento de **temperatura corporal** e **variação na coloração da pele**, com foco na **detecção de icterícia e cianose**, utilizando o microcontrolador **ESP32 Pico**.

### 1.1 Objetivos:
- Criar uma pulseira vestível e funcional para uso em ambientes de saúde pública.
- Monitorar a temperatura corporal utilizando sensor **NTC de 5k**.
- Analisar a coloração da pele com o sensor **TCS3200**.
- Utilizar inteligência artificial para identificar variações de cor associadas a **icterícia** e **cianose**.
- Estimar o **grau de variação** da coloração da pele: `Estável`, `Leve`, `Mediana` ou `Alta`.
- Permitir identificação rápida do paciente via **tag RFID**.

## 2. Fluxo de Uso:
- O paciente recebe uma pulseira com sua tag RFID.
- A pulseira coleta periodicamente a **temperatura corporal** e a **cor da pele (RGB)**.
- Os dados são enviados para o banco de dados em nuvem.
- A **IA processa os dados** e identifica se há variação significativa na cor da pele.
- Se detectada, a IA classifica:
  - **Se é icterícia ou cianose**.
  - **Grau da variação** da condição.

## 3. Funcionamento:
- A pulseira tem um ID único salvo em sua tag RFID.
- Os dados coletados (temperatura e cor da pele) são enviados via Wi-Fi para o **Realtime Database**.
- O sensor **TCS3200** coleta as cores RGB da pele.
- Uma **rede neural** compara os valores anteriores e atuais, enquanto uma **floresta randômica (Random Forest)** classifica o **grau da alteração**.
- O sistema já é capaz de identificar casos de:
  - **Icterícia** (coloração amarelada)
  - **Cianose** (coloração azulada)
- A pulseira pode ser lida com um dispositivo com leitor RFID e display, que consulta os dados do paciente diretamente no banco de dados.

## 4. Tutorial de Montagem:
- **NTC de 5k (Sensor de Temperatura)**: Conectar ao pino **23** do ESP32 Pico. Utilizar resistor de **5kΩ** em paralelo.
- **Sensor TCS3200 (Sensor de Cor)**: Conectar os pinos S0–S3 e OUT aos pinos digitais do ESP32 Pico.
- **RFID**: Utilizar um leitor compatível com SPI, conectando os pinos ao ESP32 Pico.
- **Alimentação**: Bateria ligada ao **TP4056**, passando por um **switch**, conectando ao **VIN (5V)** do ESP32.
- **Botão**: Um lado no **GND**, outro na **porta 2** do ESP32.
- **LED Indicador**: Com resistor de **330Ω**, conectado à **porta 4** do ESP32.

## 5. Mudanças Implementadas:
- Substituição do Arduino Mega pelo **ESP32 Pico**.
- **Remoção do aplicativo de monitoramento**.
- **Remoção do sensor de batimentos MAX30100**.
- **Adição do sensor TCS3200** para análise da coloração da pele.
- **Implementação da IA** (rede neural + floresta randômica).
- Sistema já é capaz de **detectar e classificar** casos de **icterícia e cianose** com base na variação da cor da pele.

## 6. Possíveis Atualizações Futuras:
- Adição do sensor **MAX30120** para retomada do monitoramento cardíaco.
- Expansão do modelo de IA para detecção de **doenças dermatológicas mais complexas**, como **câncer de pele**.
- Melhorias no consumo de energia e integração de baterias recarregáveis de longa duração.

---
