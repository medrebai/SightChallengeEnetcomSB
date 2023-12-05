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
#define SENSOR  13
 
long currentMillis = 0;
long previousMillis = 0;
int interval = 1000;
boolean ledState = LOW;
float calibrationFactor = 4.5;
volatile byte pulseCount;
byte pulse1Sec = 0;
float flowRate;
unsigned long flowMilliLitres;
unsigned int totalMilliLitres;
float flowLitres;
float totalLitres;

const int turbidityPin = A18;  
const int ledPin = 13;       

 
void IRAM_ATTR pulseCounter()
{
  pulseCount++;
}
 

 
void setup()
{
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


  config.api_key = API_KEY;


  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  config.database_url = DATABASE_URL;


  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h



  fbdo.setBSSLBufferSize(4096 , 1024 );


  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);


 
  pulseCount = 0;
  flowRate = 0.0;
  flowMilliLitres = 0;
  totalMilliLitres = 0;
  previousMillis = 0;

 attachInterrupt(digitalPinToInterrupt(SENSOR), pulseCounter, FALLING);
  pinMode(turbidityPin, INPUT) ;
  pinMode(ledPin, OUTPUT);
}
 
void loop()
{
  Firebase.signUp(&config, &auth ,USER_EMAIL,USER_PASSWORD);
  int turbidityValue = analogRead(turbidityPin);

  
  int quality = map(turbidityValue, 0, 1023, 0, 100);

  Serial.print("Turbidity: ");
  Serial.print(turbidityValue);
  Serial.print(", Water Quality: ");
  Serial.println(quality);


  if (quality > 200) {
    Serial.println("good");  
    Firebase.setString(fbdo, "/app/Water Quality", "good");
  } else {
    Serial.println("not good");  
    Firebase.setString(fbdo, "/app/Water Quality", "not good");
  }

  delay(500);  // Ajustez selon vos besoins


  delay(2000);  // 2 seconds
  currentMillis = millis();
//  if (currentMillis - previousMillis > interval) 
//  {
    
    pulse1Sec = pulseCount;
    pulseCount = 0;
 

    flowRate = ((1000.0 / (millis() - previousMillis)) * pulse1Sec) / calibrationFactor;
    previousMillis = millis();
 
    flowMilliLitres = (flowRate / 60) * 1000;
    flowLitres = (flowRate / 60);
 
   
    totalMilliLitres += flowMilliLitres;
    totalLitres += flowLitres;
    
    Serial.print("Flow rate: ");
    Serial.print(float(flowRate));  
    Serial.print("L/min");
    Serial.print("\t");  
    Firebase.setInt(fbdo ,"/app/waterDevice1", flowRate) ;
 
    
    Serial.print("Output Liquid Quantity: ");
    Serial.print(totalMilliLitres);
    Serial.print("mL / ");
    Serial.print(totalLitres);
    Serial.println("L");
    Firebase.setInt(fbdo ,"/app/WaterFlow",totalLitres ,"L" ) ;

   
  
  
 

    
 // }
  
}
