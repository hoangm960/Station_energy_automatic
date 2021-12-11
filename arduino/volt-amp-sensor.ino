#include <PZEM004Tv30.h>
#include <SoftwareSerial.h>

#if !defined(PZEM_RX_PIN) && !defined(PZEM_TX_PIN)
#define PZEM_RX_PIN 11
#define PZEM_TX_PIN 15
#endif

SoftwareSerial pzemSWSerial(PZEM_RX_PIN, PZEM_TX_PIN);
PZEM004Tv30 pzem(pzemSWSerial);

int vDCPin = A0;
int cDCPin = A1;
double average = 0;
double currentDC = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  double voltageDC = map(analogRead(vDCPin),0,1023, 0, 2500); 
  voltageDC /= 100;
  for(int i = 0; i < 1000; i++) {
    average = average + (13.51 - .0264 * analogRead(cDCPin));
    delay(1);
  }
  average /= 1000;
  currentDC = average;
  average = 0;

  Serial.print("VoltageDC: ");
  Serial.print(voltageDC);
  Serial.println("V");
  Serial.print("CurrentDC: ");
  Serial.print(currentDC);
  Serial.println("A");

  float voltageAC = pzem.voltage();
  float currentAC = pzem.current();
  float powerAC = pzem.power();
  float energyAC = pzem.energy();
  float frequencyAC = pzem.frequency();
  float pfAC = pzem.pf();

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
      Serial.print("VoltageAC: ");      Serial.print(voltageAC);      Serial.println("V");
      Serial.print("CurrentAC: ");      Serial.print(currentAC);      Serial.println("A");
      Serial.print("PowerAC: ");        Serial.print(powerAC);        Serial.println("W");
      Serial.print("EnergyAC: ");       Serial.print(energyAC,3);     Serial.println("kWh");
      Serial.print("FrequencyAC: ");    Serial.print(frequencyAC, 1); Serial.println("Hz");
      Serial.print("PFAC: ");           Serial.println(pfAC);
  }
  delay(100);
}
