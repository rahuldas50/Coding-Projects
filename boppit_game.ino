int pinArray[] = {3, 4, 5, 6, 7, 8, 10};
const int Buttonpin = 2;
int i = 0;
int begin = 500;
unsigned long interval = 500;
unsigned long previousMillis = 0;


void setup() {
  for (i = 0; i < 7; i++) {
    pinMode(pinArray[i], OUTPUT);
  }
  pinMode(buttonPin, INPUT);
}


void loop() {
  int buttonState = digitalRead(Buttonpin);
  unsigned long currentMillis = millis();
  switch (i) {
    case 0:
      digitalWrite(4, LOW);
      digitalWrite(3, HIGH);
      break;
    case 1:
      digitalWrite(3, LOW);
      digitalWrite(4, HIGH);
      break;
    case 2:
      digitalWrite(4, LOW);
      digitalWrite(5, HIGH);
      break;
    case 3:
      digitalWrite(5, LOW);
      digitalWrite(6, HIGH);
      break;
    case 4:
      digitalWrite(6, LOW);
      digitalWrite(7, HIGH);
      break;
    case 5:
      digitalWrite(7, LOW);
      digitalWrite(8, HIGH);
      break;
    case 6:
      digitalWrite(8, LOW);
      digitalWrite(10, HIGH);
      break;
    case 7:
      digitalWrite(10, LOW);
      digitalWrite(8, HIGH);
      break;
    case 8:
      digitalWrite(8, LOW);
      digitalWrite(7, HIGH);
      break;
    case 9:
      digitalWrite(7, LOW);
      digitalWrite(6, HIGH);
      break;
    case 10: digitalWrite(6, LOW);
      digitalWrite(5, HIGH);
      break;
    case 11: digitalWrite(5, LOW);
      digitalWrite(4, HIGH);
      break;
  }


  if (buttonState == HIGH) {
    if (i == 3 || i == 9) {
      interval = interval / 2;
    }
    else if (i == 2 || i == 4 || i == 8 || i == 10) {
      interval = interval;
    }
    else {
      interval = begin;
    }
    delay(2000);
  }
  if (i == 12) {
    i = 0;

  } else {
    if ((unsigned long)(currentMillis - previousMillis) >= interval) {
      i = i + 1;
      previousMillis = millis();
    }
  }
}
