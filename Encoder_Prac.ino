int count = 0;
int Button_Pin = 8;
int buttonState = 0;

void setup() {
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(Button_Pin, INPUT);
  attachInterrupt(digitalPinToInterrupt(2), A_Signal, RISING);
  attachInterrupt(digitalPinToInterrupt(3), B_Signal, RISING);
  Serial.begin(9600);
}

void loop() {
  Serial.println(count);
  delay(500);
  }



void A_Signal() {
  if (digitalRead(3) == HIGH) {
    count++;
  } else {
    count--;
  }
}

void B_Signal() {
  if (digitalRead(2) == LOW) {
    count++;
  } else {
    count--;
  }
}
