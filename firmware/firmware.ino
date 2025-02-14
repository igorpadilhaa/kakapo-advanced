// Constantes
const int ntcPin = 34; // Pino conectado ao divisor de tensão
const float seriesResistor = 10000.0; // Resistor fixo (em ohms)
const float nominalResistance = 10000.0; // Resistência nominal do NTC a 25°C
const float nominalTemperature = 25.0; // Temperatura nominal em graus Celsius
const float bCoefficient = 3950.0; // Coeficiente Beta do NTC
const float realSupplyVoltage = 3.3; // Tensão de alimentação real do ESP32 (em volts)

void setup() {
  Serial.begin(9600); // Inicializa a comunicação serial
}

void loop() {
  // Lê a tensão no pino analógico
  int analogValue = analogRead(ntcPin);
  
  // Ajuste para a tensão de alimentação real
  float voltage = analogValue * (realSupplyVoltage / 4095.0);

  // Exibe a tensão medida no pino para depuração
  Serial.print("Tensão medida no pino: ");
  Serial.print(voltage);
  Serial.println(" V");

  // Calcula a resistência do NTC
  float ntcResistance = seriesResistor * (realSupplyVoltage / voltage - 1);

  // Exibe a resistência calculada para depuração
  Serial.print("Resistência do NTC: ");
  Serial.print(ntcResistance);
  Serial.println(" ohms");

  // Fórmula para temperatura (em Kelvin)
  float temperatureKelvin = 1.0 / (1.0 / (nominalTemperature + 273.15) + 
                        (1.0 / bCoefficient) * log(ntcResistance / nominalResistance));

  // Converte para Celsius
  float temperatureCelsius = temperatureKelvin - 273.15+6;

  // Exibe a temperatura no monitor serial
  Serial.print("Temperatura: ");
  Serial.print(temperatureCelsius);
  Serial.println(" °C");

  delay(1000); // Atualiza a leitura a cada 1 segundo
}
