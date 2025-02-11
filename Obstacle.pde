class Obstacle {
  PVector pos;
  PVector vel;
  PVector coinPos;
  float size;
  boolean hasCoin;
  boolean flying;
  int cactiIndex;
  
  Obstacle() {
    size = height / 10;
    pos = new PVector(width + 100, (height * 0.8) - size / 2);
    vel = new PVector(width / -2.0, 0);
    coinPos = new PVector(pos.x, pos.y - random(height * 0.12, height * 0.35));
    flying = random(0, 1) < 0.33;
    if (flying) {
      pos.y -= random(height * 0.12, height * 0.35);
    }
    hasCoin = random(0, 1) <= 0.50 && !flying;
    cactiIndex = int(random(0,3));
  }
  
  void draw() {
    rectMode(CENTER);
    fill(color(255, 0, 0));
    imageMode(CENTER);
    if (flying) {
      image(bird, pos.x, pos.y);
    } else {
      image(cacti[cactiIndex], pos.x, pos.y);
    }
    if (hasCoin) {
      imageMode(CENTER);
      image(coin, coinPos.x, coinPos.y);
    }
  }
  
  void update(float deltaTime) {
    pos.add(PVector.mult(PVector.mult(vel, deltaTime), speedMult));
    coinPos.x = pos.x;
  }
}
