class Weapon {
  PImage img;
  boolean reloading;
  float angle;
  
  Weapon() {
    img = loadImage("gun.png");
    img = scaleImage(img, constrain(height / 360, 1, 10));
    reloading = false;
    angle = 0;
  }
  
  void draw() {
    pushMatrix();
    translate(player.pos.x + height / 36.0, player.pos.y + height / 135.0);
    if (facingLeft) {
      translate(height / -36.0, 0);
      scale(-1, 1);
    }
    rotate(angle);
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();
    
    if (reloading) {
      if (abs(angle) > 0.05) {
        angle += angle * deltaTime * -5;
      } else {
        angle = 0;
        reloading = false;
      }
    }
  }
  
  void fire() {
    if (!reloading) {
      fireSound.trigger();
      if (facingLeft) {
        bullets.add(new Projectile(player.pos.x - height / 36., player.pos.y));
      } else {
        bullets.add(new Projectile(player.pos.x + height / 36., player.pos.y));
      }
      reloading = true;
      angle = -PI / 6;
    }
  }
}
