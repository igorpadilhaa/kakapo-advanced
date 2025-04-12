#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "SSID";
const char* password = "PASSWORD";

String serverName = "FIREBASE_URL";

const int ntcPin = 34;
const float seriesResistor = 10000.0;     // Resistor fixo (em ohms)
const float nominalResistance = 10000.0;  // Resistência nominal do NTC a 25°C
const float nominalTemperature = 25.0;    // Temperatura nominal em graus Celsius
const float bCoefficient = 3950.0;        // Coeficiente Beta do NTC
const float realSupplyVoltage = 3.3;      // Tensão de alimentação real do ESP32 (em volts)

#define S0 4
#define S1 7
#define S2 8 
#define S3 5
#define OUT 22

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

  pinMode(ntcPin, INPUT);

  pinMode(S0, OUTPUT);
  digitalWrite(S0, HIGH);

  pinMode(S1, OUTPUT);
  digitalWrite(S1, LOW);

  pinMode(S2, OUTPUT);
  pinMode(S3, OUTPUT);
  pinMode(OUT, INPUT);
}

void loop() {
  float t = ler_temperatura();
  
  unsigned int red, green, blue;
  ler_cor(red, green, blue);

  registrar(t, red, green, blue);

  Serial.print("Temperatura: ");
  Serial.print(t);
  Serial.println(" °C");
  delay(5000);
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

void registrar(float temperatura, unsigned int red, unsigned int green, unsigned blue) {
  StaticJsonDocument<200> jsonDoc;
  StaticJsonDocument<200> arrayBuf;

  JsonArray array = arrayBuf.to<JsonArray>();
  array.add(red);
  array.add(green);
  array.add(blue);

  jsonDoc["temperatura"] = temperatura;
  jsonDoc["rgb"] =  array;
  
  String jsonString;
  serializeJson(jsonDoc, jsonString);
  
  HTTPClient http;
  http.begin(serverName + "/pulseira/73b06a10.json" );
  http.addHeader("Content-Type", "application/json");

  int httpCode = http.PUT(jsonString);
  Serial.print("Resposta: ");
  Serial.println(httpCode);

  String payload = http.getString();
  Serial.println("- payload: ");
  Serial.println(payload);
  
  http.end();
}

void ler_cor(unsigned int &red, unsigned int &green, unsigned int &blue) {
  digitalWrite(S2, LOW); digitalWrite(S3, LOW);
  red = pulseIn(OUT, LOW);

  digitalWrite(S2, HIGH); digitalWrite(S3, HIGH);
  green = pulseIn(OUT, LOW);

  digitalWrite(S2, LOW); digitalWrite(S3, HIGH);
  blue = pulseIn(OUT, LOW);

  String json = "{\"red\":" + String(red) + ",\"green\":" + String(green) + ",\"blue\":" + String(blue) + "}";
  Serial.println(json);

  red = map(red, 3460, 743, 0, 255);
  green = map(green, 2450, 1860, 0, 255);
  blue = map(blue, 2830, 1250, 0, 255);

  json = "{\"red\":" + String(red) + ",\"green\":" + String(green) + ",\"blue\":" + String(blue) + "}";
  Serial.println(json);
}
