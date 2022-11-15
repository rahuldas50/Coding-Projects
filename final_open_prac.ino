#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x27, 16, 2);

const int Buzzer_Pin = 8;
const int Trigger_Pin = 6;
const int Echo_Pin = 5;
const int Led_Pin = 4;
long Led_State;
long duration;
int Distance;

void setup() {
  lcd.init();
  lcd.backlight();
  pinMode(Trigger_Pin, OUTPUT);
  pinMode(Echo_Pin, INPUT);
  pinMode(Buzzer_Pin, OUTPUT);
  pinMode(Led_Pin, INPUT);

}
void loop() {
  digitalWrite(Trigger_Pin, LOW);
  delayMicroseconds(10);
  digitalWrite(Trigger_Pin, HIGH);
  delayMicroseconds(10);
  digitalWrite(Trigger_Pin, LOW);
  duration = pulseIn(Echo_Pin, HIGH);

  Distance = duration * 0.05;


  lcd.setCursor(0, 1);
  lcd.print("Distance: ");
  lcd.print(Distance);
  lcd.print(" metres");
  delay(10);

  Led_State = (Led_Pin, INPUT);

  if (Distance < 45) {
    tone(Buzzer_Pin, 1000);
    Led_State == HIGH;
    lcd.setCursor(0, 0);
    lcd.print("Too close!");
  } else {
    lcd.setCursor(0, 0);
    lcd.print("All good!");
    Led_State == LOW;
    noTone(Buzzer_Pin);
  }

}
