#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "SSID";
const char* password = "PASSWORD";

String serverName = "FIREBASE-URL";

const int ntcPin = 34;
const float seriesResistor = 10000.0;     // Resistor fixo (em ohms)
const float nominalResistance = 10000.0;  // Resistência nominal do NTC a 25°C
const float nominalTemperature = 25.0;    // Temperatura nominal em graus Celsius
const float bCoefficient = 3950.0;        // Coeficiente Beta do NTC
const float realSupplyVoltage = 3.3;      // Tensão de alimentação real do ESP32 (em volts)

const int botaoPin = 33;
const int ledPin = 25;

void setup() {
  Serial.begin(115200);
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando-se ao Wi-Fi...");
  }
  
  Serial.println("Conectado ao Wi-Fi!");
  Serial.print("Endereço IP: ");
  Serial.println(WiFi.localIP());

  pinMode(ledPin, OUTPUT);

  pinMode(ntcPin, INPUT);
  pinMode(botaoPin, INPUT_PULLUP);
}

void loop() {
  static bool ligado = false;
  
  if (digitalRead(botaoPin) == LOW) {
    ligado = !ligado;
    digitalWrite(ledPin, ligado? HIGH : LOW);

    Serial.println("Apertado!");
    delay(500);
  }
  
  if (ligado) {
    float t = ler_temperatura();
    registra_temperatura(t);
  
    Serial.print("Temperatura: ");
    Serial.print(t);
    Serial.println(" °C");
    delay(10000);
  }
}

float ler_temperatura() {
  int analogValue = analogRead(ntcPin);
  
  float voltage = analogValue * (realSupplyVoltage / 4095.0);

  Serial.print("Tensão medida no pino: ");
  Serial.print(voltage);
  Serial.println(" V");

  float ntcResistance = seriesResistor * (realSupplyVoltage / voltage - 1);

  Serial.print("Resistência do NTC: ");
  Serial.print(ntcResistance);
  Serial.println(" ohms");

  float temperatureKelvin = 1.0 / (1.0 / (nominalTemperature + 273.15) + 
                        (1.0 / bCoefficient) * log(ntcResistance / nominalResistance));

  float temperatureCelsius = temperatureKelvin - 273.15+6;
  return temperatureCelsius;
}

void registra_temperatura(float temperatura) {
  StaticJsonDocument<200> jsonDoc;
  jsonDoc["temperatura"] = temperatura;
  
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  
  HTTPClient http;
  http.begin(serverName + "/pulseira/1.json" );
  http.addHeader("Content-Type", "application/json");

  int httpCode = http.PUT(jsonString);
  Serial.print("Resposta: ");
  Serial.println(httpCode);

  String payload = http.getString();
  Serial.println("- payload: ");
  Serial.println(payload);
  
  http.end();
}
