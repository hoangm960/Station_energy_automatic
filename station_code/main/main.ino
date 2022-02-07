#include <PZEM004Tv30.h>
#include <SoftwareSerial.h>
#include <Adafruit_Fingerprint.h>
#if !defined(PZEM_RX_PIN) && !defined(PZEM_TX_PIN)
#define PZEM_RX_PIN 11
#define PZEM_TX_PIN 15
#endif

SoftwareSerial pzemSWSerial(PZEM_RX_PIN, PZEM_TX_PIN);
PZEM004Tv30 pzem(pzemSWSerial);
Adafruit_Fingerprint finger = Adafruit_Fingerprint(&Serial1);

int vDCPin = A0;
int cDCPin = A1;
double average = 0;
double currentDC = 0;
int check_finger = 0;
uint8_t id;
int fingerVoltPin = 2;
bool fingerOn = false;
int relayPin = 4;
int relayVoltPin = 3;

void setup() {
  Serial.begin(9600);
  finger.begin(57600);
  pinMode(fingerVoltPin, OUTPUT);
  pinMode(relayPin, OUTPUT);
  pinMode(relayVoltPin, OUTPUT);
  digitalWrite(relayVoltPin, HIGH);
}

void loop() {
  int val = Serial.read();
  if (val == '1') {
    check_finger = 1;
  }
  if (val == '2') {
    check_finger = 2;
  }
  switch (check_finger) {
    case 0:
      getEnergyInfo();  
      break;
    case 1:
      digitalWrite(fingerVoltPin, HIGH);
      while (check_finger == 1) {
        getFingerprintID();
      }
      digitalWrite(fingerVoltPin, LOW);
      break;
    case 2:
      digitalWrite(fingerVoltPin, HIGH);
      while (check_finger == 2) {enrollFingerprint();}
      digitalWrite(fingerVoltPin, LOW);
      break;
    default:
      getEnergyInfo();
      break;
  }
}

void activateRelay() {
    digitalWrite(relayPin, HIGH);
    delay(5000);
    digitalWrite(relayPin, LOW);
}

void getEnergyInfo() {
  double voltageDC = map(analogRead(vDCPin),0,1023, 0, 2500); 
  voltageDC /= 100;
  for(int i = 0; i < 1000; i++) {
    average = average + (13.51 - .0264 * analogRead(cDCPin));
    delay(1);
  }
  average /= 1000;
  if (average > 0) {
    currentDC = average;
  }else {
    currentDC = 0;
  }
  average = 0;

  float voltageAC = pzem.voltage();
  float currentAC = pzem.current();
  float powerAC = pzem.power();
  float energyAC = pzem.energy();
  float frequencyAC = pzem.frequency();
  float pfAC = pzem.pf();

  Serial.print("VoltageDC: ");
  Serial.print(voltageDC);
  Serial.println(" V");
  Serial.print("CurrentDC: ");
  Serial.print(currentDC);
  Serial.println(" A");

  if(isnan(voltageAC)){
      Serial.println("Out AC: Error reading voltage");
  } else if (isnan(currentAC)) {
      Serial.println("Out AC: Error reading current");
  } else if (isnan(powerAC)) {
      Serial.println("Out AC: Error reading power");
  } else if (isnan(energyAC)) {
      Serial.println("Out AC: Error reading energy");
  } else if (isnan(frequencyAC)) {
      Serial.println("Out AC: Error reading frequency");
  } else if (isnan(pfAC)) {
      Serial.println("Out AC: Error reading power factor");
  } else {
      Serial.print("VoltageAC: ");      Serial.print(voltageAC);      Serial.println(" V");
      Serial.print("CurrentAC: ");      Serial.print(currentAC);      Serial.println(" A");
      Serial.print("PowerAC: ");        Serial.print(powerAC);        Serial.println(" W");
      Serial.print("EnergyAC: ");       Serial.print(energyAC,3);     Serial.println(" kWh");
      Serial.print("FrequencyAC: ");    Serial.print(frequencyAC, 1); Serial.println(" Hz");
      Serial.print("PFAC: ");           Serial.println(pfAC);
  }
  delay(100);
}

void enrollFingerprint() {
  Serial.println("Ready to enroll a fingerprint!");
  Serial.println("Please type in the ID # (from 1 to 127) you want to save this finger as...");
  id = readnumber();
  if (id == 0) {// ID #0 not allowed, try again!
     return;
  }
  Serial.print("Enrolling ID #");
  Serial.println(id);

  while (!  getFingerprintEnroll() );
  check_finger = 0;
}

uint8_t readnumber(void) {
  uint8_t num = 0;

  while (num == 0) {
    while (! Serial.available());
    num = Serial.parseInt();
  }
  return num;
}

uint8_t getFingerprintEnroll() {

  int p = -1;
  Serial.print("Waiting for valid finger to enroll as #"); Serial.println(id);
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      break;
    default:
      Serial.println("Unknown error");
      break;
    }
  }

  // OK success!

  p = finger.image2Tz(1);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  Serial.println("Remove finger");
  delay(2000);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  Serial.print("ID "); Serial.println(id);
  p = -1;
  Serial.println("Place same finger again");
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.print(".");
      break;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      break;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      break;
    default:
      Serial.println("Unknown error");
      break;
    }
  }

  // OK success!

  p = finger.image2Tz(2);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK converted!
  Serial.print("Creating model for #");  Serial.println(id);

  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    Serial.println("Prints matched!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_ENROLLMISMATCH) {
    Serial.println("Fingerprints did not match");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }

  Serial.print("ID "); Serial.println(id);
  p = finger.storeModel(id);
  if (p == FINGERPRINT_OK) {
    Serial.println("Stored!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    Serial.println("Could not store in that location");
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    Serial.println("Error writing to flash");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }

  return true;
}

uint8_t getFingerprintID() {
  
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println("No finger detected");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK success!

  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK converted!
  p = finger.fingerSearch();
  if (p == FINGERPRINT_OK) {
    Serial.println("Found a print match!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_NOTFOUND) {
    Serial.println("Did not find a match");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }

  // found a match!
  Serial.print("Found ID #"); Serial.print(finger.fingerID);
  Serial.print(" with confidence of "); Serial.println(finger.confidence);

  check_finger = 0;
  activateRelay();
  delay(100);
  return finger.fingerID;
}
