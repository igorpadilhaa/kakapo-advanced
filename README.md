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

## 1. Pulseira Inteligente para Monitoramento de Temperatura

O projeto a ser desenvolvido consiste na criação de uma **pulseira inteligente** que realizará o monitoramento da temperatura corporal utilizando o microcontrolador **ESP32 Pico**. O sistema será composto por um **NTC de 5k** para medição de temperatura.

O NTC de 5k será responsável por monitorar a variação de temperatura. A pulseira inteligente irá exibir essas informações por meio de uma interface simples no dispositivo, podendo ser integrada a outras plataformas para monitoramento em tempo real.

O desenvolvimento será realizado na plataforma **Arduino IDE**, utilizando a programação do **ESP32 Pico** para controlar a leitura dos sensores e a exibição das informações.

### 1.1 Objetivos:

- Criar uma pulseira inteligente para monitoramento de temperatura.
- Integrar o ESP32 Pico com o NTC de 5k para coleta de dados de saúde.
- Desenvolver a programação para mostrar os dados de temperatura em tempo real.
- Explorar o uso do ESP32 Pico em dispositivos vestíveis para saúde.
- Implementar um sistema de identificação rápida via RFID.
- Criar um aplicativo para monitoramento e gerenciamento dos dados dos pacientes.

## 2. Fluxo de Uso:

- Ao chegar na UBS, o paciente recebe uma pulseira com seus dados gravados.
- Os agentes da UBS conseguem monitorar o estado do paciente e visualizar suas informações de identificação no aplicativo.
- O paciente pode ser identificado através da pulseira, usando um leitor especial. O leitor tem uma tela que mostra os dados da pulseira.

## 3. Funcionamento:

- A pulseira tem um ID gravado na sua Tag único e envia os dados para um documento com o mesmo nome do ID no Realtime Database.
- O aplicativo vai registrar os pacientes conectados a uma pulseira. Isso será feito criando um documento no Firestore com os dados do paciente, o ID do documento será o ID da pulseira que o paciente usa.
- O leitor terá um LCD ou OLED e um leitor RFID. Ele será capaz de ler a tag de identificação da pulseira e consultar os dados do paciente no Firestore, mostrando isso no display.

## 4. Tutorial de Montagem:

- **NTC de 5k (Sensor de Temperatura)**: Conecte o pino ligado ao resistor do NTC ao pino analógico **22** do ESP32 Pico. O VCC vai ao **3,3V** e o GND ao **GND**. Utilize um resistor de **5kΩ** em série para calibrar o sensor.
- **Leitor RFID**: Conecte o leitor RFID ao ESP32 Pico conforme a documentação do fabricante.
- **Alimentação**: A alimentação pode ser feita via cabo USB ou por uma fonte externa compatível, como uma bateria de lítio recarregável ou uma fonte de 3,3V.

## 5. Mudanças Implementadas:

- O aplicativo agora cadastra os dados do paciente junto da pulseira.
- Implementação de um novo dispositivo de leitura.
- A pulseira agora possui uma **cartão NFC**.
- Integração entre os dados do Realtime Database e Firestore.
- Substituição do **Arduino Mega** pelo **ESP32 Pico**.
- Removido o sensor de batimento cardíaco MAX30100 devido a problemas técnicos.

