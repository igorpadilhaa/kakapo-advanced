---

# Projeto1-VictorC-RyanK-IgorP_UFRR_2024

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
    

## 1. Pulseira Inteligente para Monitoramento de Temperatura e Batimento Cardíaco

O projeto a ser desenvolvido consiste na criação de uma **pulseira inteligente** que realizará o monitoramento da temperatura corporal e dos batimentos cardíacos utilizando o microcontrolador **Arduino Mega**. O sistema será composto por dois sensores principais: um **NTC de 5k** para medição de temperatura e um **sensor de batimento cardíaco MAX30100** para medir os batimentos cardíacos.

O NTC de 5k será responsável por monitorar a variação de temperatura, e o sensor MAX30100 realizará a medição dos batimentos cardíacos. A pulseira inteligente irá exibir essas informações por meio de uma interface simples no dispositivo, podendo ser integrada a outras plataformas para monitoramento em tempo real.

O desenvolvimento será realizado na plataforma **Arduino IDE**, utilizando a programação do **Arduino Mega** para controlar a leitura dos sensores e a exibição das informações.

### 1.1 Objetivos:
- Criar uma pulseira inteligente para monitoramento de temperatura e batimentos cardíacos.
- Integrar o Arduino Mega com o NTC de 5k e o sensor MAX30100 para coleta de dados de saúde.
- Desenvolver a programação para mostrar os dados de temperatura e batimento cardíaco em tempo real.
- Explorar o uso do Arduino Mega em dispositivos vestíveis para saúde.

## 2. Tutorial de Montagem:
- **NTC de 5k (Sensor de Temperatura)**: Conecte o pino ligado ao resistor do NTC ao pino analógico **A0** do Arduino Mega. O VCC vai ao **5V** e o GND ao **GND**. Utilize um resistor de **5kΩ** em série para calibrar o sensor.
- **Sensor de Batimento Cardíaco MAX30100**: Conecte os pinos **SCL** e **SDA** aos pinos **SCL (21)** e **SDA (20)** do Arduino Mega, respectivamente. O VCC vai ao **5V** e o GND ao **GND**.
- **Alimentação**: A alimentação pode ser feita via cabo USB ou por uma fonte externa compatível, como uma bateria de lítio recarregável ou uma fonte de 5V.
### 2.1 Circuito:
<p align="center">  
  <img src="https://github.com/VictorH456/kakapo-1-sprint0/blob/main/Imagens/circuito.png" width="480px">
</p>
---
