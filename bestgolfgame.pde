float friction;
int golferX;
int golferY;
int golferDirection;
int golferSpeed;
int holeX;
int holeY;
int walkAnimation;
int walkDirection;
int[][] grass;
int chargeStartTime;
float chargePower;
int swingStartTime;
float baseSpeed;
// Instead of an enum, you could use multiple boolean variables
enum State {
  READY, CHARGINGPOWER, SWING, BALLLAUNCHED, ENDGAME
}
State gameState;
float[][] balls; 
int ballsLaunched;
boolean launchedMaxBalls;


void setup() {
  size(1280, 960);
  resetGame();
}


void draw() {
  drawBackground(); 
  drawGrass();
  drawHole();
  drawBalls();
  checkCollision();
  drawFlag();
  drawGolfer();
  updateGolfer();
  checkWin();
}


void keyPressed() {
  switch(gameState) {
  case READY:
    gameState = State.CHARGINGPOWER;
    chargeStartTime = millis();
    break;
  case CHARGINGPOWER:
    gameState = State.SWING;
    float timeElapsed = calculateTimeElapsed(chargeStartTime);
    // This line uses a ternary operator, which is a type of conditional (search online!)
    chargePower = (timeElapsed < 4.0) ? timeElapsed : 4.0;
    swingStartTime = millis();
    break;
  case ENDGAME:
    if (key == 'g' || key == 'G') {
      resetGame();
      loop();
    } else if (key == 'x' || key == 'X') {
      exit();
    }
  default:
    break;
  }
}


void drawBackground() {
  noStroke();
  background(255);
  fill(125);
  rect(0, 576, width, height);
}


void generateGrass() {
  for (int i = 0; i < grass.length; i++) {
    for (int j = 0; j < grass[0].length; j++) {
      grass[i][j] = (int) random(100, 255);
    }
  }
}


void drawGrass() {
  for (int i = 0; i < grass.length; i++) {
    for (int j = 0; j < grass[0].length; j++) {
      fill(50, grass[i][j], 50);
      rect(i * 64, j * 64, 64, 64);
    }
  }
}


void drawGolfer() {
  // Body
  stroke(0);
  strokeWeight(5);
  line(golferX, golferY, golferX-40, golferY+135);
  // Legs
  line(golferX-40, golferY+135, golferX-40 + walkAnimation, golferY+270);
  line(golferX-40, golferY+135, golferX-46 - walkAnimation, golferY+260);
  // Feet
  line(golferX-40 + walkAnimation, golferY+270, golferX  + walkAnimation, golferY+271);
  line(golferX-46 - walkAnimation, golferY+260, golferX-6 - walkAnimation, golferY+259);
  // Head
  fill(255);
  ellipse(golferX, golferY, 80, 80);
  // Eye
  ellipse(golferX+25, golferY - 10, 10, 10);
  // Mouth
  noFill();
  arc(golferX+35, golferY, 30, 30, HALF_PI, PI);

  animateGolfSwing();
}


void updateGolfer() {
  if (gameState == State.READY) {
    if (abs(walkAnimation) > 30) {
      walkDirection *= -1;
    }
    walkAnimation += walkDirection;
    if (golferX <= 46 || golferX >= width - 105) {
      golferDirection *= -1;
    }
    golferX += golferSpeed * golferDirection;
  }
}


float calculateTimeElapsed(int startTime) {
  return (millis() - startTime) / 1000.00;
}


void animateGolfSwing() {
  fill(0);
  strokeWeight(8);
  switch(gameState) {
  case CHARGINGPOWER:
    int timeElapsed = (int) calculateTimeElapsed(chargeStartTime);
    // Draw a different animation based on time elapsed
    if (timeElapsed >= 4) {
      drawClubStage5();
    } else if (timeElapsed >= 3) {
      drawClubStage4();
    } else if (timeElapsed >= 2) {
      drawClubStage3();
    } else if (timeElapsed >= 1) {
      drawClubStage2();
    } else {
      drawClubStage1();
    }
    drawStationaryBall();
    break;
  case SWING:
    float timeElapsed1 = calculateTimeElapsed(swingStartTime);
    if (timeElapsed1 >= 0.1) {
      drawStationaryClub();
      drawStationaryBall();
      gameState = State.BALLLAUNCHED;
      addBall();
    } else {
      drawClubStage2();
      drawStationaryBall();
    }
    break;
  case BALLLAUNCHED:
    float timeElapsed2 = calculateTimeElapsed(swingStartTime);
    if (timeElapsed2 >= 1.2) {
      gameState = State.READY;
    } else if (timeElapsed2 >= 0.2) {
      drawClubStage5();
    }
    break;
  default:
    drawStationaryClub();
    break;
  }
}


void drawStationaryBall() {
  noStroke();
  fill(255);
  ellipse(golferX+90, golferY+220, 30, 30);
}


void drawStationaryClub() {
  // Club
  line(golferX-20, golferY+130, golferX+80, golferY+260);
  ellipse(golferX+90, golferY+260, 30, 15);
  // Arms
  strokeWeight(5);
  line(golferX-20, golferY+68, golferX-10, golferY+150);
  line(golferX-20, golferY+68, golferX-6, golferY+150);
}

void drawClubStage1() {
  // Club
  line(golferX-20, golferY+130, golferX+40, golferY+220);
  ellipse(golferX+50, golferY+220, 30, 15);
  // Arms
  strokeWeight(5);
  line(golferX-20, golferY+68, golferX, golferY+150);
  line(golferX-20, golferY+68, golferX-20, golferY+118);
  line(golferX-20, golferY+118, golferX, golferY+150);
}


void drawClubStage2() {
  // Club
  line(golferX-70, golferY+130, golferX-150, golferY+50);
  ellipse(golferX-150, golferY+50, 30, 15);
  // Arms
  strokeWeight(5);
  line(golferX-20, golferY+68, golferX-80, golferY+120);
  line(golferX-20, golferY+68, golferX-40, golferY+110);
  line(golferX-40, golferY+110, golferX-80, golferY+120);
}


void drawClubStage3() {
  // Club
  line(golferX-110, golferY+60, golferX-140, golferY-30);
  ellipse(golferX-140, golferY-30, 30, 15);
  // Arms
  strokeWeight(5);
  line(golferX-20, golferY+68, golferX-120, golferY+50);
  line(golferX-20, golferY+68, golferX-70, golferY+80);
  line(golferX-70, golferY+80, golferX-120, golferY+50);
}


void drawClubStage4() {
  // Club
  line(golferX-100, golferY-30, golferX-110, golferY-80);
  ellipse(golferX-110, golferY-80, 30, 15);
  // Arms
  strokeWeight(5);
  line(golferX-20, golferY+68, golferX-100, golferY-40);
  line(golferX-20, golferY+68, golferX-80, golferY+50);
  line(golferX-80, golferY+50, golferX-100, golferY-40);
}


void drawClubStage5() {
  // Club
  ellipse(golferX-100, golferY-40, 30, 15);
  // Arms
  strokeWeight(5);
  line(golferX-20, golferY+68, golferX-100, golferY-40);
  line(golferX-20, golferY+68, golferX-80, golferY+50);
  line(golferX-80, golferY+50, golferX-100, golferY-40);
}


void drawBalls() {
  fill(0);
  int numBalls = calculateNumBalls();
  for (int i = 0; i < numBalls; i++) {
    float ballX = balls[i][0];
    float ballY = balls[i][1];
    float ballVelocity = balls[i][2];

    // Make ball bounce off top and bottom walls
    if (ballY <= 15 || ballY >= height - 15) {
      ballVelocity *= -1;
    }

    float newBallY = ballY - ballVelocity;
    drawBall(ballX, ballY);

    // Update ball velocity for next frame
    float newBallVelocity = ballVelocity * friction;
    balls[i][2] = newBallVelocity;
    balls[i][1] = newBallY;
  }
}


void drawBall(float x, float y) {
  fill(255);
  ellipse(x, y, 30, 30);
}


void addBall() {
  if (ballsLaunched == 10) {
    launchedMaxBalls = true;
    ballsLaunched = 0;
  }
  balls[ballsLaunched][0] = golferX + 90; 
  balls[ballsLaunched][1] = golferY + 220;
  balls[ballsLaunched][2] = chargePower * baseSpeed;
  ballsLaunched++;
}


void placeHole() {
  // These positions are within the grass
  holeX = (int) random(150, width - 25);
  holeY = (int) random(25, 521);
}


void drawHole() {
  fill(255);
  stroke(0);
  strokeWeight(1);
  ellipse(holeX, holeY, 50, 30);
  fill(50);
  ellipse(holeX, holeY, 38, 22);
  noStroke();
}


void drawFlag() {
  fill(200, 50, 50);
  rectMode(CORNERS);
  rect(holeX - 15, holeY - 50, holeX - 10, holeY + 8);
  fill(255);
  rect(holeX - 15, holeY - 100, holeX - 10, holeY - 50);
  fill(200, 50, 50);
  rect(holeX - 15, holeY - 150, holeX - 10, holeY - 100);
  fill(255);
  rect(holeX - 15, holeY - 200, holeX - 10, holeY - 150);
  fill(200, 50, 50);
  triangle(holeX - 10, holeY - 200, holeX + 60, holeY - 175, holeX - 10, holeY - 150);
  rectMode(CORNER);
}


void checkWin() {
  int numBalls = calculateNumBalls();
  for (int i = 0; i < numBalls; i++) {
    float ballX = balls[i][0];
    float ballY = balls[i][1];
    float ballVelocity = balls[i][2];
    if (dist(holeX, holeY, ballX, ballY) < 15 && abs(ballVelocity) < 0.3) {
      gameState = State.ENDGAME;
      break;
    }
  }
  if (gameState == State.ENDGAME) {
    endgameScreen();
  }
}


int calculateNumBalls() {
  // This is used because once 10 balls are reached
  // old balls are replaced by new ones
  if (launchedMaxBalls) {
    return 10;
  } else {
    return ballsLaunched;
  }
}


void endgameScreen() {
  textSize(50);
  fill(0);
  text("Congratulations! You've won!", 240, 100);
  text("Press x to exit or g to play again!", 200, 200);
  noLoop();
}


void resetGame() {
  friction = 0.99;
  golferX = width/2;
  golferY = (int) (height * 0.55);
  golferSpeed = 2;
  golferDirection = 1;
  walkAnimation = 0;
  walkDirection = 1;
  grass = new int[20][10];
  generateGrass();
  gameState = State.READY;
  baseSpeed = 2.0;
  balls = new float[10][3];
  ballsLaunched = 0;
  launchedMaxBalls = false;
  placeHole();
}


void checkCollision() {
  // Note: this is quite a basic implementation of collision
  // This can be done in a much more natural way
  int loopCondition = calculateNumBalls();
  for (int i = 0; i < loopCondition; i++) {
    for (int j = i + 1; j < loopCondition; j++) {
      float ball1X = balls[i][0];
      float ball1Y = balls[i][1];
      float ball2X = balls[j][0];
      float ball2Y = balls[j][1];
      if (dist(ball1X, ball1Y, ball2X, ball2Y) <= 30) {
        // transfer half of the energy from the faster ball to the slower
        float ball1Velocity = balls[i][2];
        float ball2Velocity = balls[j][2];
        if (ball1Velocity > ball2Velocity) {
          float newVelocity = ball1Velocity / 2;
          balls[i][2] = newVelocity;
          balls[j][2] = ball2Velocity + newVelocity;
        } else {
          float newVelocity = ball2Velocity / 2;
          balls[i][2] = ball1Velocity + newVelocity;
          balls[j][2] = newVelocity;
        }
      }
    }
  }
}
