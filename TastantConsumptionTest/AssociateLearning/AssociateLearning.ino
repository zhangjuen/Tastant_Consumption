#include <Wire.h>
#include <Servo.h>
#include "Adafruit_MPR121.h"
Adafruit_MPR121 cap = Adafruit_MPR121();

Servo JuenSservoM;
Servo JuenSservoL;
Servo JuenSservoR;
uint16_t currtouched = 0;
int MtouchPin = 0;
int LtouchPin = 2;
int RtouchPin = 1;
int MservoPos[2] = {80,140};//
int MservoPosOld = MservoPos[0];
int MservoPosNew = MservoPos[1];
int LservoPos[2] = {35,47};//37 47
int LservoPosOld = LservoPos[0];
int LservoPosNew = LservoPos[1];
int RservoPos[2] = {127,115};
int RservoPosOld = RservoPos[0];
int RservoPosNew = RservoPos[1];


int inputs = 0;

int MportPin = 2; // trigger  22
int LportPin = 3; // trigger 30
int RportPin = 4;//trigger 34

int MpumpPin1 = 22;// pin high or low
int MpumpPin2 = 24;// pin high or low
int MpumpPin3 = 26;// 
int MpumpPin4 = 28;// 
int MpumpPin5 = 30;// 
int MpumpPin6 = 32;// 
int MpumpPin7 = 34;// 
int LpumpPin = 47; // trigger
int RpumpPin = 49;// trigger


int odorPin1 = 23;
int odorPin2 = 25;
int odorPin3 = 27;
int odorPin4 = 29;
int odorSuckPin = 31;
int airPuffPin = 33; // trigger
int suckPin1 = 35; // pin high or low
int suckPin2 = 37; // pin hig or low


int MservoGatePin = 36;
int LservoGatePin = 38;
int RservoGatePin = 40;

int tonePin = 11;
int MLickSignalPin = 44;
int laserPin = 52; //trigger



int i = 0;
int startToneFre = 1500;
int toneCueFre = 5000;
int toneCueDur = 50;
int startToneDur = 300;
int TimeNowPrint = 60;


boolean LpumpMode = 0;
boolean RpumpMode = 0;
boolean MpumpMode1 = 0;
boolean MpumpMode2 = 0;
boolean MpumpMode3 = 0;
boolean MpumpMode4 = 0;
boolean MpumpMode5 = 0;
boolean MpumpMode6 = 0;
boolean MpumpMode7 = 0;
boolean airPuffMode = 0;
boolean MportMode = 0;
boolean LportMode = 0;
boolean RportMode = 0;
boolean LaserMode = 0;
boolean LaserOnMode = 0;
boolean LaserOffMode = 0;

int Mtouch = 0;
int Ltouch = 0;
int Rtouch = 0;
int ServoMoveM = 1;
boolean ServoMoveL = 1;
boolean ServoMoveR = 1;
unsigned long ServoStepTimeM = 30;
unsigned long ServoInitialTimeM = 10;
unsigned long ServoMoveTimeM = 0;
unsigned long ServoStepTimeL = 80;
unsigned long ServoMoveTimeL = 0;
unsigned long ServoStepTimeR = 80;
unsigned long ServoMoveTimeR = 0;
unsigned long LPumpTrigTime = 25;
unsigned long RPumpTrigTime = 25;
unsigned long MPumpTrigTime1 = 20;
unsigned long MPumpTrigTime2 = 20;
unsigned long MPumpTrigTime3 = 20;
unsigned long MPumpTrigTime4 = 20;
unsigned long MPumpTrigTime5 = 20;
unsigned long MPumpTrigTime6 = 20;
unsigned long MPumpTrigTime7 = 20;

unsigned long MPumpStartTime1 = 0;
unsigned long MPumpStartTime2 = 0;
unsigned long MPumpStartTime3 = 0;
unsigned long MPumpStartTime4 = 0;
unsigned long MPumpStartTime5 = 0;
unsigned long MPumpStartTime6 = 0;
unsigned long MPumpStartTime7 = 0;
unsigned long LPumpStartTime = 0;
unsigned long RPumpStartTime = 0;

unsigned long puffTime = 100;
unsigned long timeServoM = 0;
unsigned long timeTrialStart = 0;
unsigned long timeNow = 0;

unsigned long PuffStartTime = 0;
unsigned long LaserOnTime = 0;
unsigned long LaserOffTime = 0;
unsigned long laserPulse = 5;
unsigned long laserOff = 45;
unsigned long PulseDur[4] = {1,2,5,10};
unsigned long Frequency[9] = {1,2,5,10,20,40,50,80,100};


//LED laser
int LEDLaserPin[2] = {46,39};
unsigned long LEDOnTime = 0;
unsigned long LEDOffTime = 0;
unsigned long LEDPulse = 90;
unsigned long LEDOff = 10;
unsigned long LEDstartTime = 0;
unsigned long LEDTrigDuration = 500;//total duration per trig
int LEDMode = 0;
boolean LEDOnMode = 0;
boolean LEDOffMode = 0;

int ruptPin = 2; // select the input pin for the interrupter
int PhotoInVal = 0; // variable to store the value coming from the sensor
int PhotoInTag = 2; 

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600); 
for(i=5;i<=10;i++)
{
  pinMode(i,OUTPUT);
  }

for (i = 22;i<=53;i++)
{
//  if (~(i==MportPin||i==LportPin||i==RportPin))
  {pinMode(i,OUTPUT);
  digitalWrite(i,LOW);}
}
digitalWrite(MservoGatePin,HIGH);
//digitalWrite(LservoGatePin,HIGH);
//digitalWrite(RservoGatePin,HIGH);
JuenSservoM.attach(MportPin);
JuenSservoL.attach(LportPin);
JuenSservoR.attach(RportPin);
JuenSservoM.write(MservoPos[1]);
//JuenSservoR.write(RservoPos[1]);
//JuenSservoL.write(LservoPos[1]);

pinMode(tonePin,OUTPUT);
int PhotoInTag = 2; 
cap.begin(0x5A);



}

void loop() {
  //read Serial input, and set trial parameters
// touch sensor
//delay(100);
//int16_t a = cap.filteredData(2);
//int16_t b = cap.baselineData(2);
//Serial.print(a-b); Serial.print("\t");
//

timeNow = millis();
//Serial.println(timeNow);
currtouched = cap.touched();

if ((currtouched & (1<<MtouchPin))&&Mtouch==0) {  Serial.print('M'); Mtouch = 1; digitalWrite(MLickSignalPin,HIGH); }
else if ((!(currtouched & (1<<MtouchPin)))&&Mtouch==1) {Mtouch = 0;digitalWrite(MLickSignalPin,LOW); }
if ((currtouched & (1<<LtouchPin))&&Ltouch==0) {  Serial.print('L');Ltouch = 1;  }
else if ((!(currtouched & (1<<LtouchPin)))&&Ltouch==1) {Ltouch = 0;}
if ((currtouched & (1<<RtouchPin))&&Rtouch==0) {  Serial.print('R'); Rtouch = 1;  }
else if ((!(currtouched & (1<<RtouchPin)))&&Rtouch==1) {Rtouch = 0;}
//photo interrupter
if (PhotoInTag==0) {
	PhotoInVal = analogRead(ruptPin); // read the value from the sensor
    if (PhotoInVal<300)  {Serial.println('I'); PhotoInTag=1;}
    }
 else if (PhotoInTag==1) {
 PhotoInVal = analogRead(ruptPin); // read the value from the sensor
    if (PhotoInVal>900)  {Serial.println('i'); PhotoInTag=0;}
    }
  
  // read serial input
if (Serial.available() > 0 ) 
{
  inputs = Serial.read();  
  //Serial.println(inputs);
  if (inputs==0)
  {
    // all out put set zero
    LaserMode = 0;    LEDMode = 0;
    for (i = 22;i<=53;i++)  {if (i!=MservoGatePin) {digitalWrite(i,LOW);} }//don't turn off M servo gate pin, because it is stable now
    }  //0, reset    
if (inputs==100) {cap.begin(0x5A);}//reset touch sensor
   //timeNow output
   else if (inputs==TimeNowPrint) {Serial.print('T');Serial.print(timeNow);Serial.print('t'); }
  // tone cue
if (inputs == tonePin){  tone(tonePin,toneCueFre,toneCueDur);  }
else if (inputs-100 == tonePin) {tone(tonePin, startToneFre,startToneDur);}
else if (inputs == tonePin+4) {tone(tonePin,toneCueFre);digitalWrite(12,HIGH);}
else if (inputs-100 == tonePin+4) {noTone(tonePin);digitalWrite(12,LOW);}
else if (inputs == 12) {digitalWrite(12,HIGH);}
else if (inputs-100 == 12){digitalWrite(12,LOW);}
// all pin Gate mode, on/off mode
if (inputs>=22&&inputs<=53) { digitalWrite(inputs,HIGH); }
if (inputs-100>=22&&inputs-100<=53) { digitalWrite(inputs-100,LOW); }
   
  //M L R pump, odor pump
  // on off mode
//if (inputs==MpumpPin1||inputs==MpumpPin2||inputs==MpumpPin3||inputs==MpumpPin4||inputs==MpumpPin5){  digitalWrite(inputs,HIGH);  }
//else if (inputs-100==MpumpPin1||inputs-100==MpumpPin2||inputs-100==MpumpPin3||inputs-100==MpumpPin4||inputs-100==MpumpPin5){  digitalWrite(inputs-100,LOW);  }
//if (inputs==LpumpPin||inputs==RpumpPin) {digitalWrite(inputs,HIGH); }
//else if (inputs-100==LpumpPin||inputs-100==RpumpPin) {digitalWrite(inputs-100,LOW); }
//trigger Mode
if (inputs-200 == MpumpPin1) { MpumpMode1 = 1; MPumpStartTime1 = timeNow; digitalWrite(MpumpPin1,HIGH);}
else if (inputs-200 == MpumpPin2) { MpumpMode2 = 1; MPumpStartTime2 = timeNow; digitalWrite(MpumpPin2,HIGH);}
else if (inputs-200 == MpumpPin3) { MpumpMode3 = 1; MPumpStartTime3 = timeNow; digitalWrite(MpumpPin3,HIGH);}
else if (inputs-200 == MpumpPin4) { MpumpMode4 = 1; MPumpStartTime4 = timeNow; digitalWrite(MpumpPin4,HIGH);}
else if (inputs-200 == MpumpPin5) { MpumpMode5 = 1; MPumpStartTime5 = timeNow; digitalWrite(MpumpPin5,HIGH);}
else if (inputs-200 == MpumpPin6) { MpumpMode6 = 1; MPumpStartTime6 = timeNow; digitalWrite(MpumpPin6,HIGH);}
else if (inputs-200 == MpumpPin7) { MpumpMode7 = 1; MPumpStartTime7 = timeNow; digitalWrite(MpumpPin7,HIGH);}
else if (inputs-200 == LpumpPin)  { LpumpMode = 1;  LPumpStartTime = timeNow;  digitalWrite(LpumpPin,HIGH); } //close should be out of serial read loop  //
else if (inputs-200 == RpumpPin)  { RpumpMode = 1;  RPumpStartTime = timeNow;  digitalWrite(RpumpPin,HIGH); } //close should be out of serial read loop
  //air puff
//if (inputs == airPuffPin ) {digitalWrite(airPuffPin,HIGH);}
//else if (inputs-100 == airPuffPin ) {digitalWrite(airPuffPin,LOW);}
if (inputs-200 == airPuffPin) {  airPuffMode = 1;  PuffStartTime = timeNow;  digitalWrite(airPuffPin,HIGH);    }
//close should be out of serial read loop
  //servo
if (inputs==MportPin)     {digitalWrite(MservoGatePin,HIGH);ServoMoveM = 2;ServoMoveTimeM = millis();JuenSservoM.attach(MportPin);PhotoInTag=0;} //initial
else if (inputs-100==MportPin) {digitalWrite(MservoGatePin,HIGH);ServoMoveM = 3;ServoMoveTimeM = millis();JuenSservoM.attach(MportPin);PhotoInTag=2;}//photoTag 2: stop check

if (inputs==LportPin)     {digitalWrite(LservoGatePin,HIGH);ServoMoveL = 1; LservoPosOld = JuenSservoL.read(); LservoPosNew = LservoPos[0];ServoMoveTimeL = timeNow;}//JuenSservoL.write(LservoPos[0]);
else if (inputs-100==LportPin) {digitalWrite(LservoGatePin,HIGH);ServoMoveL = 1; LservoPosOld = JuenSservoL.read(); LservoPosNew = LservoPos[1];ServoMoveTimeL = timeNow;}//JuenSservoL.write(LservoPos[1]);  
if (inputs==RportPin)     {digitalWrite(RservoGatePin,HIGH);ServoMoveR = 1; RservoPosOld = JuenSservoR.read(); RservoPosNew = RservoPos[0];ServoMoveTimeR = timeNow;}//JuenSservoR.write(RservoPos[0]);
else if (inputs-100==RportPin) {digitalWrite(RservoGatePin,HIGH);ServoMoveR = 1; RservoPosOld = JuenSservoR.read(); RservoPosNew = RservoPos[1];ServoMoveTimeR = timeNow;}//JuenSservoR.write(RservoPos[1]);



//laser
if (inputs == laserPin)  { digitalWrite(laserPin,HIGH); }
else if (inputs-200 == laserPin) {LaserOnTime = timeNow; LaserMode = 1; digitalWrite(laserPin,HIGH);LaserOnMode = 1; }//pulse control out of serial input
else if (inputs-100 == laserPin) {LaserMode = 0;digitalWrite(laserPin,LOW);LaserOnMode = 0; LaserOffMode = 0;}
else if (inputs-200 == LEDLaserPin[0]){LEDMode = 1;LEDOnTime = timeNow; digitalWrite(LEDLaserPin[0],HIGH);LEDOnMode = 1;LEDstartTime = timeNow;}
else if (inputs-200 == LEDLaserPin[1]){LEDMode = 2;LEDOnTime = timeNow; digitalWrite(LEDLaserPin[1],HIGH);LEDOnMode = 1;LEDstartTime = timeNow;}
else if (inputs-100 == LEDLaserPin[0]||inputs-100 == LEDLaserPin[1]) {LEDMode = 0;LaserOnMode = 0; LaserOffMode = 0;}
//change laser parameter
else if (inputs-80>=0&&inputs-80<=3){laserPulse = PulseDur[inputs-80];}
else if (inputs-90>=0&&inputs-90<=8) {laserOff = 1000/Frequency[inputs-90]-laserPulse;}

}//serial read end

//pump Trig end
if (MpumpMode1 == 1&&(timeNow - MPumpStartTime1>MPumpTrigTime1)){ MpumpMode1 = 0; digitalWrite(MpumpPin1,LOW);}
if (MpumpMode2 == 1&&(timeNow - MPumpStartTime2>MPumpTrigTime2)){ MpumpMode2 = 0; digitalWrite(MpumpPin2,LOW);}
if (MpumpMode3 == 1&&(timeNow - MPumpStartTime3>MPumpTrigTime3)){ MpumpMode3 = 0; digitalWrite(MpumpPin3,LOW);}
if (MpumpMode4 == 1&&(timeNow - MPumpStartTime4>MPumpTrigTime4)){ MpumpMode4 = 0; digitalWrite(MpumpPin4,LOW);}
if (MpumpMode5 == 1&&(timeNow - MPumpStartTime5>MPumpTrigTime5)){ MpumpMode5 = 0; digitalWrite(MpumpPin5,LOW);}
if (MpumpMode6 == 1&&(timeNow - MPumpStartTime6>MPumpTrigTime6)){ MpumpMode6 = 0; digitalWrite(MpumpPin6,LOW);}
if (MpumpMode7 == 1&&(timeNow - MPumpStartTime7>MPumpTrigTime7)){ MpumpMode7 = 0; digitalWrite(MpumpPin7,LOW);}
if (LpumpMode  == 1&&(timeNow - LPumpStartTime >LPumpTrigTime )){ LpumpMode  = 0; digitalWrite(LpumpPin, LOW);} 
if (RpumpMode  == 1&&(timeNow - RPumpStartTime >RPumpTrigTime )){ RpumpMode  = 0; digitalWrite(RpumpPin, LOW);} 
// air puff trig end
if (airPuffMode==1&&timeNow-PuffStartTime>puffTime)  {airPuffMode = 0;digitalWrite(airPuffPin,LOW);}
//laser control
if (LaserMode==1&&timeNow-LaserOnTime>=laserPulse&&LaserOnMode==1) {digitalWrite(laserPin,LOW); LaserOnMode = 0; LaserOffTime = timeNow; LaserOffMode = 1;  }
else if (LaserMode==1&&timeNow-LaserOffTime>=laserOff&&LaserOffMode==1) {digitalWrite(laserPin,HIGH); LaserOnMode = 1; LaserOnTime = timeNow; LaserOffMode = 0;}
else if (LEDMode>0)
{
  if (timeNow-LEDOnTime>=LEDPulse&&LEDOnMode==1) {digitalWrite(LEDLaserPin[LEDMode-1],LOW); LEDOnMode = 0; LEDOffTime = timeNow; LEDOffMode = 1;  }
  else if (timeNow-LEDOffTime>=LEDPulse&&LEDOffMode==1) {digitalWrite(LEDLaserPin[LEDMode-1],HIGH); LEDOffMode = 0; LEDOnTime = timeNow; LEDOnMode = 1;  }
  if (timeNow-LEDstartTime>=LEDTrigDuration) {digitalWrite(LEDLaserPin[LEDMode-1],LOW);LEDMode = 0;LEDOffMode = 0;LEDOnMode = 0;}
  }

//servo move step
if (ServoMoveM==1){ 
if (MservoPosNew!=MservoPosOld&&timeNow-ServoMoveTimeM>=ServoStepTimeM) {
  if (MservoPosOld==JuenSservoM.read()){
  MservoPosOld=JuenSservoM.read()+abs(MservoPosNew-MservoPosOld)/(MservoPosNew-MservoPosOld);JuenSservoM.write(MservoPosOld);ServoMoveTimeM =  timeNow;}
  } // if new larger than old, old + 1; if new smaller than old, old-1
else if (MservoPosNew==MservoPosOld&&timeNow-ServoMoveTimeM>=ServoStepTimeM) {
  if (MservoPosOld==JuenSservoM.read()){
  ServoMoveM = 0;JuenSservoM.detach();
  //digitalWrite(MservoGatePin,LOW);
  }
  }// servo at the target position, stop it
}
else if (ServoMoveM==2&&timeNow-ServoMoveTimeM>=ServoInitialTimeM){ServoMoveM = 1; MservoPosOld = JuenSservoM.read(); MservoPosNew = MservoPos[0];ServoMoveTimeM = timeNow;}//servo on
else if (ServoMoveM==3&&timeNow-ServoMoveTimeM>=ServoInitialTimeM){ServoMoveM = 1; MservoPosOld = JuenSservoM.read(); MservoPosNew = MservoPos[1];ServoMoveTimeM = timeNow;}//servo off


if (ServoMoveL==1){
if (LservoPosNew!=LservoPosOld&&timeNow-ServoMoveTimeL>=ServoStepTimeL) {LservoPosOld=JuenSservoL.read()+abs(LservoPosNew-LservoPosOld)/(LservoPosNew-LservoPosOld);JuenSservoL.write(LservoPosOld);ServoMoveTimeL = timeNow;} 
else if (LservoPosNew==LservoPosOld&&timeNow-ServoMoveTimeL>=ServoStepTimeL) {ServoMoveL = 0;digitalWrite(LservoGatePin,LOW);}
}
if (ServoMoveR==1){
if (RservoPosNew!=RservoPosOld&&timeNow-ServoMoveTimeR>=ServoStepTimeR) {RservoPosOld=JuenSservoR.read()+abs(RservoPosNew-RservoPosOld)/(RservoPosNew-RservoPosOld);JuenSservoR.write(RservoPosOld);ServoMoveTimeR = timeNow;} 
else if (RservoPosNew==RservoPosOld&&timeNow-ServoMoveTimeR>=ServoStepTimeR) {ServoMoveR = 0;digitalWrite(RservoGatePin,LOW);}
}

}// loop end
