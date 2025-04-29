// === GLOBAL VARIABLES ===
import processing.sound.*;

PImage carImg, coneImg, heartImg, roadImg;
Car car;
ArrayList<Obstacle> obstacles;

// Sound files
SoundFile hitSound;
SoundFile moveSound;

int moveSoundStartTime = -1;
boolean isMoveSoundPlaying = false;

int lives = 3;
float scrollSpeed = 5;
float roadScrollY = 0;

// Game states
boolean showHowTo = true;
boolean gameOver = false;
boolean gameWin = false;

int startTime;
int gameDuration = 4 * 60 * 1000; // 4 minutes in milliseconds

void setup() {
  size(600, 800);
  imageMode(CENTER);

  // Load images
  carImg = loadImage("car.png");
  coneImg = loadImage("cone.png");
  heartImg = loadImage("heart.png");
  roadImg = loadImage("road.png");

  // Load sounds

  hitSound = new SoundFile(this, "high-pitch-oops-46055.mp3");
  moveSound = new SoundFile(this, "grandprix-61253.mp3");

  

  car = new Car(300, 700, 80, 120, carImg); // bigger car
  obstacles = new ArrayList<Obstacle>();
}

void draw() {
  background(0);

  if (showHowTo) {
    drawHowToScreen();
    return;
  }

  if (gameOver) {
    drawGameOverScreen();
    return;
  }

  if (gameWin) {
    drawWinScreen();
    return;
  }

  // === Win condition ===
  if (millis() - startTime >= gameDuration) {
    gameWin = true;
    
  }

  // === Scroll road background ===
  roadScrollY += scrollSpeed;
  roadScrollY %= roadImg.height;

  for (float y = -roadImg.height; y < height + roadImg.height; y += roadImg.height) {
    image(roadImg, width / 2, y + roadScrollY);
  }

  // === Spawn cones every second ===
  if (frameCount % 60 == 0) {
    obstacles.add(new Obstacle(coneImg));
  }

  car.update();
  car.display();

  for (int i = obstacles.size() - 1; i >= 0; i--) {
    Obstacle o = obstacles.get(i);
    o.update();
    o.display();

    if (!o.wasHit && o.hits(car)) {
      o.wasHit = true;
      lives--;
      car.flash();
      hitSound.play();
    }

    if (o.offscreen()) {
      obstacles.remove(i);
    }
  }

  // Draw hearts
  for (int i = 0; i < lives; i++) {
    image(heartImg, 30 + i * 40, 40, 30, 30);
  }

  if (lives <= 0) {
    gameOver = true;

  }

  // === Shorten move sound to 0.5 seconds ===
  if (isMoveSoundPlaying && millis() - moveSoundStartTime > 500) {
    moveSound.stop();
    isMoveSoundPlaying = false;
  }
}

void keyPressed() {
  if (showHowTo && key == ENTER) {
    showHowTo = false;
    startTime = millis(); // Reset game timer
  } else if (!showHowTo && !gameOver && !gameWin) {
    if (keyCode == LEFT || keyCode == RIGHT) {
      moveSound.play();
      moveSoundStartTime = millis();
      isMoveSoundPlaying = true;
    }
  }
}

void drawHowToScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(28);
  text("HOW TO PLAY", width / 2, 150);
  textSize(20);
  text("Use LEFT and RIGHT arrow keys to move.", width / 2, 220);
  text("Avoid hitting cones.", width / 2, 260);
  text("You have 3 lives.", width / 2, 300);
  text("Survive for 4 minutes to win!", width / 2, 340);
  textSize(18);
  text("Press ENTER to start.", width / 2, 400);
}

void drawGameOverScreen() {
  background(0);
  fill(255, 0, 0);
  textAlign(CENTER);
  textSize(50);
  text("Game Over", width / 2, height / 2);
}

void drawWinScreen() {
  background(0);
  fill(0, 255, 0);
  textAlign(CENTER);
  textSize(50);
  text("You Win!", width / 2, height / 2);
}
