class Obstacle {
  float x, y, w, h;
  PImage coneImg;
  boolean wasHit = false;

  Obstacle(PImage coneImg) {
    w = 60;  // bigger cone
    h = 60;
    x = random(160, 400);
    y = -h; // spawn just above screen
    this.coneImg = coneImg;
  }

  void update() {
    y += 5; // move downward toward car
  }

  void display() {
    if (coneImg != null) {
      image(coneImg, x + w/2, y + h/2, w, h);
    } else {
      fill(255, 165, 0);
      rect(x, y, w, h);
    }
  }

  boolean hits(Car c) {
    return (c.x + c.w > x && c.x < x + w && c.y + c.h > y && c.y < y + h);
  }

  boolean offscreen() {
    return y > height;
  }
}
