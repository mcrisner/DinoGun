class Projectile {
  PVector pos;
  PVector vel;
  float wid;
  float hei;
  
  Projectile(float xPos, float yPos) {
    pos = new PVector(xPos, yPos);
    if (facingLeft) {
      vel = new PVector(-width * 1.5, 0);
    } else {
      vel = new PVector(width * 1.5, 0);
    }
    wid = bullet.width;
    hei = bullet.height;
  }
  
  void draw() {
    imageMode(CENTER);
    if (facingLeft) {
      pushMatrix();
      translate(pos.x, pos.y);
      scale(-1, 1);
      image(bullet, 0, 0);
      popMatrix();
    } else {
      image(bullet, pos.x, pos.y);
    }
    
  }
  
  void update(float deltaTime) {
    pos.add(PVector.mult(vel, deltaTime));
  }
  
}
