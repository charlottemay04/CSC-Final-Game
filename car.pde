class Car {
  float x, y, w, h;
  PImage img;
  
  boolean isFlashing = false;
  int flashTimer = 0;
  int flashDuration = 30; // frames

  Car(float x, float y, float w, float h, PImage img) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
  }

  void update() {
    if (keyPressed) {
      if (keyCode == LEFT) {
        x -= 7;
      } else if (keyCode == RIGHT) {
        x += 7;
      }
    }
    x = constrain(x, 0, width - w);

    if (isFlashing) {
      flashTimer--;
      if (flashTimer <= 0) {
        isFlashing = false;
      }
    }
  }

  void display() {
    if (isFlashing) {
      tint(255, 100); // semi-transparent flash effect
    } else {
      noTint();
    }
    image(img, x + w/2, y + h/2, w, h);
    noTint(); // reset tint
  }

  void flash() {
    isFlashing = true;
    flashTimer = flashDuration;
  }
}
