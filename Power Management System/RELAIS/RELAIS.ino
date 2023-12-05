#include "TroykaCurrent.h"
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "CoworkingSpace"
#define WIFI_PASSWORD "Cospace2021"

/* 2. Define the API Key */
#define API_KEY "AIzaSyB_rr6nfvuZPtFPkoRRS6b1YmjZFiru3vs"

/* 3. Define the RTDB URL */
#define DATABASE_URL "https://sightfinal-default-rtdb.firebaseio.com/"

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "bilel.mezghani@ieee.org"
#define USER_PASSWORD "IEEEenetcom"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

unsigned long count = 0;
const int relayPin1 = 13;  // Remplacez par la broche que vous utilisez
const int relayPin2 = 12;  // Remplacez par la broche que vous utilisez
const int relayPin3 = 14;  // Remplacez par la broche que vous utilisez

const int current1=33 ;
const int current2=25 ;
const int current3=26 ;

ACS712 sensorCurrent1(current1); // Broche de connexion du capteur
ACS712 sensorCurrent2(current2); // Broche de connexion du capteur
ACS712 sensorCurrent3(current3); // Broche de connexion du capteur

void setup() {

Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
  //Firebase.reconnectNetwork(true);

  fbdo.setBSSLBufferSize(4096 , 1024 );
  //Firebase.signUp(&config, &auth ,"","");

  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);

  
  // Initialiser la broche du relais en tant que sortie
  pinMode(relayPin1, OUTPUT);
  pinMode(relayPin2, OUTPUT);
  pinMode(relayPin3, OUTPUT);
  // Démarrer la communication série

  Serial.println("Relay control with ESP32");

 
}

void loop() {

Firebase.signUp(&config, &auth ,USER_EMAIL,USER_PASSWORD);
  
  if (Firebase.ready()) { 
 if (Firebase.get(fbdo, "/app/prise1")) {
    Serial.println(fbdo.dataPath());
    Serial.println(fbdo.payload());
    if (fbdo.payload() == "0"){
       digitalWrite(relayPin1, LOW);
       Serial.println("Relay OFF");
      }
else {
    digitalWrite(relayPin1, HIGH);
     Serial.println("Relay ON");
}}
if (Firebase.get(fbdo, "/app/prise2")) {
    Serial.println(fbdo.dataPath());
    Serial.println(fbdo.payload());
    if (fbdo.payload() == "0"){
       digitalWrite(relayPin2, LOW);
       Serial.println("Relay OFF");
      }
else {
    digitalWrite(relayPin2, HIGH);
     Serial.println("Relay ON");
}}
if (Firebase.get(fbdo, "/app/prise3")) {
    Serial.println(fbdo.dataPath());
    Serial.println(fbdo.payload());
    if (fbdo.payload() == "0"){
       digitalWrite(relayPin3, LOW);
       Serial.println("Relay OFF");
      }
else {
    digitalWrite(relayPin3, HIGH);
     Serial.println("Relay ON");
}}}
 

   
   else {
    resetESP32();
}

 int adc1 = analogRead(current1 );
  int adc2 = analogRead(current2 );
  int adc3 = analogRead(current3 );
  float voltage1 = (adc1 * 5 / 1023.0) - 2.5;
  float current1 = voltage1 / 0.100;
  float voltage2 = (adc2 * 5 / 1023.0) - 2.5;
  float current2 = voltage2 / 0.100;
  float voltage3 = (adc3 * 5 / 1023.0) - 2.5;
  float current3 = voltage3 / 0.100;
  
  if (current1 <= 0.7) {
    delay(10000);
    digitalWrite (relayPin1,LOW) ;
   
  }
  if (current2 <= 0.8) {
    delay(10000);
    digitalWrite (relayPin2,LOW) ;
   
  }
  if (current3 <= 0.5) {
    delay(10000);
    digitalWrite (relayPin3,LOW) ;
   
  }
  


 
// Adafruit_SSD1306 display(OLED_D1, OLED_D0, OLED_DC, OLED_RESET, OLED_CS);
 
 


  }
void resetESP32() {
    Serial.println("Redémarrage de l'ESP32...");
    ESP.restart();
}

  
